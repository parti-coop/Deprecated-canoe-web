class DiscussionsController < ApplicationController
  include SlackPushing
  include Messaging
  include DiscussionActivityTraking

  before_filter :authenticate_user!, except: [:show, :short]
  load_and_authorize_resource :canoe
  load_and_authorize_resource :discussion, through: :canoe, shallow: true

  def index
    limit = 30
    if user_signed_in?
      @discussions = current_user.joined_discussions.read_by(current_user).order(discussed_at: :desc).first(limit)
      @canoes = current_user.joined_canoes
      if @canoes.empty?
        @canoes = Canoe.limit(20)
      end
    end
  end

  def show
    redirect_to short_discussion_path(@discussion.canoe.slug, @discussion.sequential_id)
  end

  def short
    @canoe = Canoe.find_by slug: params[:slug]
    @discussion = @canoe.discussions.find_by sequential_id: params[:sequential_id]

    if user_signed_in?
      @discussion.mark_as_read! :for => current_user
    end
    @canoe = @discussion.canoe
    render_404 and return if @canoe.nil?

    render template: 'discussions/show'
  end

  def new
  end

  def edit
  end

  def create
    @discussion.user = current_user

    @opinion = @discussion.opinions.first
    if @opinion.present?
      if @opinion.body.blank?
        @discussion.opinions.destroy @opinion
      else
        @opinion.user = current_user if @opinion.present?
      end
    end
    if @discussion.save
      push_to_slack(@discussion)
      create_opinions_create_activty(@discussion.opinions.first) if @discussion.opinions.first.present?
      redirect_to @discussion
    else
      render 'new'
    end
  end

  def update
    if @discussion.update_attributes(update_params)
      push_to_slack(@discussion)
      create_discussions_update_decision_activty(@discussion) if @discussion.previous_changes['decision'].present?
      redirect_to @discussion
    else
      render 'edit'
    end
  end

  def destroy
    @discussion.destroy
    notify_to_crews(@discussion)
    push_to_slack(@discussion)
    redirect_to @discussion.canoe
  end

  private

  def create_params
    params.require(:discussion).permit(:subject, :canoe_id, opinions_attributes: [ :body ])
  end

  def update_params
    params.require(:discussion).permit(:subject, :body, :decision)
  end
end
