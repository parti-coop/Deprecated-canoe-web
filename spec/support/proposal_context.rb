shared_context 'proposal' do
  include_context 'helper'

  def proposals_exist(attrs_set)
    attrs_set.map do |attrs|
      FactoryGirl.create(:proposal, attrs)
    end
  end

  def create_proposal(attrs)
    expect(attrs).to have_key(:discussion_id)
    visit discussion_path(attrs[:discussion_id])
    fill_in 'proposal_body', with: attrs[:body] if attrs.has_key? :body
    click_button '제안하기'
  end

  def proposal_should_be_created(attrs)
    expect(Proposal.last_created).to_not be_nil
    proposal = Proposal.find Proposal.last_created.id
    if attrs.has_key? :user
      user = attrs.delete(:user)
      expect(user.stringify_keys.to_a - proposal.user.attributes.to_a).to be_empty
    end
    expect(attrs.stringify_keys.to_a - proposal.attributes.to_a).to be_empty
  end

  def post_to_proposal_url(discussion_id)
    page.driver.browser.post discussion_proposals_path(discussion_id)
  end

  def update_proposal(proposal_id, attrs)
    visit edit_proposal_path proposal_id
    fill_in 'Body', with: attrs[:body] if attrs.has_key? :body
    click_button '저장'
  end

  def proposal_should_be_updated(proposal_id, attrs)
    proposal = Proposal.find proposal_id
    expect(attrs.stringify_keys.to_a - proposal.attributes.to_a).to be_empty
  end

  def go_to_edit_proposal_page(proposal_id)
    do_not_follow_redirect do
      visit edit_proposal_path(proposal_id)
    end
  end

  def put_to_proposal_url(proposal_id, params = {})
    page.driver.browser.put proposal_path(proposal_id), params
  end

  def delete_to_proposal_url(proposal_id)
    page.driver.browser.delete proposal_path(proposal_id)
  end

  def proposal_should_be_deleted(proposal_id)
    expect(Proposal.exists?(proposal_id)).to be false
  end

  def user_should_see_proposal_list(discussion_id)
    user_should_see_show_discussion_page(discussion_id)
  end

end
