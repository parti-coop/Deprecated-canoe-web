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

  scenario 'User has to login to post to proposal url' do
    user_is_not_in_login_status
    post_to_proposal_url(@discussion.id)
    user_should_see_login_form
  end

  scenario 'Update proposal by owner' do
    proposal, * = proposals_exist [
      { body: 'proposal to update' }
    ]
    user_is_in_login_status_as proposal.user

    update_proposal proposal.id,
      body: 'proposal updated'

    proposal_should_be_updated proposal.id,
      body: 'proposal updated'
  end

end
