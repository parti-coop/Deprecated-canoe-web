class Api::V1::CanoeSerializer < ActiveModel::Serializer
  attributes(*Canoe.attribute_names.map(&:to_sym))
  has_one :user
end
