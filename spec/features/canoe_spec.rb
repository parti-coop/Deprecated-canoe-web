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
    user_is_in_login_status_as @valid_user
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

  scenario 'Update canoe by owner' do
    canoe, * = canoes_exist [
      { title: 'canoe title 1', slug: 'canoe-slug' }
    ]
    user_is_in_login_status_as canoe.user

    update_canoe canoe.id,
      title: 'canoe title 1 updated',
      slug: 'canoe-slug-updated'

    canoe_should_be_updated canoe.id,
      title: 'canoe title 1 updated',
      slug: 'canoe-slug-updated'
  end

  scenario 'User has to login to go to edit canoe page' do
    canoe, * = canoes_exist [
      { title: 'canoe title to edit' }
    ]
    user_is_not_in_login_status
    go_to_edit_canoe_page canoe.id
    user_should_see_login_form
  end

  scenario 'List canoe user owns only' do
    canoes_exist [
      { title: 'canoe title 1', user: @valid_user },
      { title: 'canoe title 2' }
    ]
    user_is_in_login_status_as @valid_user
    go_to_list_canoe_page
    page_should_have_canoe_list [
      { title: 'canoe title 1' }
    ]
  end

  scenario 'List empty with no canoe' do
    canoes_not_exist
    user_is_in_login_status_as @valid_user
    go_to_list_canoe_page
    page_should_have_empty_canoe_list
  end

  scenario 'User has to login to go to new canoe page' do
    user_is_not_in_login_status
    go_to_new_canoe_page
    user_should_see_login_form
  end

  scenario 'User has to login to post to create canoe url' do
    user_is_not_in_login_status
    post_to_create_canoe_url
    user_should_see_login_form
  end

end
