FactoryGirl.define do

  factory :user do
    email 'test@example.com'
  end

  factory :canoe do
    title 'canoe title by factory'
    user
  end

end
