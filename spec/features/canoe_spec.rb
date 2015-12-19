require 'rails_helper'

feature 'Canoe' do
  include_context 'auth'
  include_context 'canoe'

  scenario 'Create new canoe by valid user' do
    sign_in_as 'valid-user@email.com'
    create_canoe title: 'Canoe created by scenario'
    canoe_should_be_created(
      title: 'Canoe created by scenario',
      user: { email: 'valid-user@email.com' }
    )
  end

end
