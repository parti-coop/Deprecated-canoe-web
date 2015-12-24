require 'rails_helper'

feature 'Canoe' do
  include_context 'user'
  include_context 'auth'
  include_context 'canoe'

  background do
    @valid_user, * = users_exist [
      { email: 'valid-user@email.com' }
    ]
  end

  scenario 'Create new canoe by valid user' do
    sign_in_as @valid_user
    create_canoe(
      title: 'Canoe created by scenario',
      slug: 'canoe-slug'
    )
    canoe_should_be_created(
      title: 'Canoe created by scenario',
      slug: 'canoe-slug',
      user: { email: 'valid-user@email.com' }
    )
  end

  scenario 'List canoe user owns only' do
    canoes_exist [
      { title: 'canoe title 1', user: @valid_user },
      { title: 'canoe title 2' }
    ]
    sign_in_as @valid_user
    go_to_list_canoe_page
    page_should_have_canoe_list [
      { title: 'canoe title 1' }
    ]
  end

  scenario 'List empty with no canoe' do
    canoes_not_exist
    sign_in_as @valid_user
    go_to_list_canoe_page
    page_should_have_empty_canoe_list
  end

end
