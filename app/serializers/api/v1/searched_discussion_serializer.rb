class Api::V1::SearchedDiscussionSerializer < ActiveModel::Serializer
  attributes(*(Discussion.attribute_names.map(&:to_sym) << :matched_proposal << :matched_opinion))
  has_one :user
  has_one :canoe

  cattr_accessor :serializer_params
  def initialize(serializer, object)
    super
    @serializer_params = object[:serializer_params]
  end

  def matched_proposal
    object.matched_newest_proposal(@serializer_params[:q])
  end

  def matched_opinion
    object.matched_newest_opinion(@serializer_params[:q])
  end
end
