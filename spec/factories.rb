FactoryGirl.define do

  factory :user do
    email 'factory@email.com'
  end

  factory :canoe do
    title 'canoe title by factory'
    user
  end

end
