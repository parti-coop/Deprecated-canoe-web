shared_context 'auth' do

  def sign_in_as(user)
    scope = Devise::Mapping.find_scope!(user)
    devise_mapping = Devise.mappings[scope]
    path = Devise.cas_service_url('', devise_mapping)
    visit "#{path}?ticket=#{user.email}"
  end

end
