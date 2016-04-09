class Api::V1::ProposalSerializer < ActiveModel::Serializer
  attributes(*Proposal.attribute_names.map(&:to_sym))
  has_one :user
end
