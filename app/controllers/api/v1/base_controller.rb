class Api::V1::BaseController < Api::BaseController
  version 1

  before_filter :authenticate_token!

  def user_signed_in?
    @current_user.present?
  end

  def current_user
    @current_user
  end

  def push_to_client(object)
  end

  private

  def authenticate_token!
    nickname = request.headers["X-CANOE-USER-NICKNAME"]
    auth_token = request.headers["X-CANOE-AUTH-TOKEN"]
    user = User.find_by(nickname: nickname)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, auth_token)
      @current_user = user
    end

    error! :unauthenticated unless @current_user.present?
  end

  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user       = user_email && User.find_by_email(user_email)

    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    end
  end

  def refute_captain!
    if @canoe.captain?(current_user)
      error! :forbidden, metadata: { error_description: 'You are captain' }
    end
  end

  def refute_blank!(something, model_name)
    if something.blank?
      error! :forbidden, metadata: { error_description: "#{model_name} is not present" }
    end
  end

  def assert_canoe!
    error! :not_found, metadata: { error_description: 'Not found canoe' } if @canoe.nil?
  end

  def assert_crew!
    if !@canoe.crew?(current_user)
      error! :forbidden, metadata: { error_description: 'You are not crew' }
    end
  end

  def refute_crew!
    refute_crew_of!(current_user)
  end

  def refute_crew_of!(someone)
    if @canoe.crew?(someone)
      error! :forbidden, metadata: { error_description: "@#{someone.nickname} is already crew" }
    end
  end

  def assert_canoe_to_be_able_to_request_to_join!
    if !@canoe.is_able_to_request_to_join?
      error! :conflict, 'This canoe was prohibited to request to join'
    end
  end

  def refute_invited!
    refute_invited_of!(current_user)
  end

  def refute_invited_of!(someone)
    if @canoe.invited?(someone)
      error! :conflict, "@#{someone.nickname} is already invited"
    end
  end

  def assert_current_user!(someone)
    if someone != current_user
      error! :forbidden
    end
  end

  def assert_crew_or_current_user!(someone)
    if someone != current_user and !@canoe.crew?(current_user)
      error! :forbidden
    end
  end

  def hashed_detail_canoe(canoe)
    canoe.serializable_hash(include: {
      user: {},
      crews: { include: [:user] },
      request_to_joins: { include: [:user] },
      invitations: { include: [:user] },
    }).update(am_i_crew?: canoe.crew?(current_user), have_requested_to_join?: canoe.request_to_join?(current_user))
  end

  def hashed_basic_canoe(canoe)
    canoe.serializable_hash(include: {
      user: {}
    }).update(am_i_crew?: canoe.crew?(current_user), have_requested_to_join?: canoe.request_to_join?(current_user))
  end

  def hashed_basic_proposal(proposal)
    proposal.serializable_hash(include: {
      user: {}
    }).update(vote_by_me: proposal.votes.find_by(user: current_user))
  end

  def hashed_detail_discussion(discussion)
    discussion.serializable_hash(include: {
      user: {}
    }).update(
      activities: hashed_activities(discussion),
      canoe: hashed_basic_canoe(discussion.canoe),
      proposals: discussion.proposals.map{ |p| hashed_basic_proposal(p) })
  end

  def hashed_activities(discussion)
    activities = discussion.activities_merged
    activities.map do |first_activity, activities_groups|
      if first_activity.key == 'opinion'
        opinion = first_activity.subject
        {
          type: 'opinion',
          user: opinion.user.serializable_hash,
          items: [opinion.serializable_hash]
        }
      else
        {
          type: 'activity',
          user: first_activity.owner.serializable_hash,
          items: activities_groups.map do |activities_group|
            subject = activities_group[:subject]
            activities = activities_group[:activities]
            key = activities.first.key
            ac = ActionController::Base.new()
            {
              subject_type: key,
              subject: subject.serializable_hash,
              details: ac.render_to_string(partial: "public_activity/app/#{key.gsub('.','/')}", locals: { subject: subject, activities: activities })
            }
          end
        }
      end
    end
  end

  def hashed_discussions_with_newest(discussions)
    discussions.map do |discussion|
      discussion.serializable_hash(include: [:user, :canoe]).merge(
        newest_opinion: discussion.newest_opinion.try(:serializable_hash, {include: [:user]}),
        newest_proposal: discussion.newest_proposal.try(:serializable_hash, {include: [:user]}))
    end
  end

  def hashed_page_meta(collection)
    {
      count: collection.total_count,
      pagination: RocketPants::Respondable.extract_pagination(collection)
    }
  end
end
