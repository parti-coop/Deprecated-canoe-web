require 'rails_helper'

feature 'Proposal' do
  include_context 'user'
  include_context 'discussion'
  include_context 'proposal'

  background do
    @valid_user, * = users_exist [
      { email: 'valid-user@email.com' }
    ]
    @discussion, * = discussions_exist [
      { subject: 'Discussion for proposal spec' }
    ]
  end

  scenario 'Create new proposal by valid user' do
    user_is_in_login_status_as @valid_user
    create_proposal(
      discussion_id: @discussion.id,
      body: "Proposal created by scenario"
    )
    proposal_should_be_created(
      discussion_id: @discussion.id,
      body: "Proposal created by scenario",
      user: { email: 'valid-user@email.com' }
    )
  end

end
