shared_context 'user' do

  def users_exist(attrs_set)
    attrs_set.map do |attrs|
      FactoryGirl.create(:user, attrs)
    end
  end

  def user_is_in_login_status_as(user)
    scope = Devise::Mapping.find_scope!(user)
    devise_mapping = Devise.mappings[scope]
    path = Devise.cas_service_url('', devise_mapping)
    visit "#{path}?ticket=#{user.email}"
  end

  def user_is_not_in_login_status
    logout(:user)
  end

  def user_should_see_login_form
    expect(page.status_code).to eq(302)
    expect(page.response_headers['Location']).to match %r{/app/users/sign_in}
  end

end
