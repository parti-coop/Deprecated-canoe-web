require 'rails_helper'

feature 'Canoe' do

  scenario 'Create new canoe' do
    sign_in_as 'valid-user@email.com'
    create_canoe_titled 'Canoe created by scenario'
    canoe_should_be_created title: 'Canoe created by scenario'
  end

  def create_canoe_titled(title)
    visit new_canoe_path
    fill_in 'Title', with: title
    click_button '저장'
  end

  def sign_in_as(email)
    user = FactoryGirl.create(:user, email: email)
    scope = Devise::Mapping.find_scope!(user)
    devise_mapping = Devise.mappings[scope]
    path = Devise.cas_service_url('', devise_mapping)
    visit "#{path}?ticket=#{user.email}"
  end

  def canoe_should_be_created(attrs)
    canoe = Canoe.find Canoe.last_created.id
    expect(attrs.stringify_keys.to_a - canoe.attributes.to_a).to be_empty
  end

end
