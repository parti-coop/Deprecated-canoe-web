require 'rails_helper'

feature 'Canoe' do
  include_context 'auth'
  include_context 'canoe'
  include_context 'page'

  scenario 'Create new canoe by valid user' do
    sign_in_as 'valid-user@email.com'
    create_canoe title: 'Canoe created by scenario'
    canoe_should_be_created(
      title: 'Canoe created by scenario',
      user: { email: 'valid-user@email.com' }
    )
  end

  scenario 'List one canoe' do
    set_all_canoes ( [ title: 'The only canoe' ] )
    go_to_list_canoe_page
    page_should_have_canoe_list( [ title: 'The only canoe' ] )
  end

  scenario 'List empty with no canoe' do
    set_no_canoe_exists
    go_to_list_canoe_page
    page_should_have_empty_canoe_list
  end

end
