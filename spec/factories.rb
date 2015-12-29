FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "factory-#{n}@email.com" }
    sequence(:nickname) { |n| "factory-nick-#{n}" }
  end

  factory :canoe do
    title 'canoe title by factory'
    sequence(:slug) { |n| "factory-canoe-#{n}-slug" }
    user
  end

  factory :discussion do
    subject 'discussion subject by factory'
    body 'discussion body by factory'
    canoe
    user
  end

  factory :proposal do
    body 'proposal body by factory'
    discussion
    user
  end

end
