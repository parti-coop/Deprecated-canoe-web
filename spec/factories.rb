FactoryGirl.define do

  factory :user do
    email 'factory@email.com'
    sequence(:nickname) { |n| "factory-nick-#{n}" }
  end

  factory :canoe do
    title 'canoe title by factory'
    sequence(:slug) { |n| "factory-canoe-#{n}-slug" }
    user
  end

end
