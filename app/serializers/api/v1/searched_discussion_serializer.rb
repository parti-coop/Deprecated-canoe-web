class Api::V1::SearchedDiscussionSerializer < ActiveModel::Serializer
  attributes :discussion, :matched_proposal, :matched_opinion

  def initialize(serializer, object)
    super
    @serialization_options = object[:serializer_params]
  end

  def matched_proposal
    object.matched_newest_proposal(@serialization_options[:q])
  end

  def matched_opinion
    object.matched_newest_opinion(@serialization_options[:q])
  end
end
