class Api::BaseController < RocketPants::Base

  map_error! ActiveRecord::RecordNotFound, RocketPants::NotFound

  # For the api to always revalidate on expiry.
  caching_options[:must_revalidate] = true

  def api?
    true
  end

  def hashed_discussions_with_newest(discussions)
    discussions.map do |discussion|
      discussion.serializable_hash(include: [:user, :canoe]).merge(
        newest_opinion: discussion.newest_opinion.try(:serializable_hash, {include: [:user]}),
        newest_proposal: discussion.newest_proposal.try(:serializable_hash, {include: [:user]}))
    end
  end
end
