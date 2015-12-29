shared_context 'proposal' do

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

end
