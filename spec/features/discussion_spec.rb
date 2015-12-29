require 'rails_helper'

feature 'Discussion' do
  include_context 'user'
  include_context 'canoe'
  include_context 'discussion'

  background do
    @valid_user, * = users_exist [
      { email: 'valid-user@email.com' }
    ]
    @canoe, * = canoes_exist [
      { title: 'Canoe for discussion spec' }
    ]
  end

  scenario 'Create new discussion by valid user' do
    user_is_in_login_status_as @valid_user
    create_discussion(
      canoe_id: @canoe.id,
      subject: 'Discussion created by scenario'
    )
    discussion_should_be_created(
      canoe_id: @canoe.id,
      subject: 'Discussion created by scenario',
      user: { email: 'valid-user@email.com' }
    )
  end

  scenario 'User has to login to go to new discussion page' do
    user_is_not_in_login_status
    go_to_new_discussion_page @canoe.id
    user_should_see_login_form
  end

  scenario 'User has to login to post to discussion url' do
    user_is_not_in_login_status
    post_to_discussion_url(@canoe.id)
    user_should_see_login_form
  end

end
