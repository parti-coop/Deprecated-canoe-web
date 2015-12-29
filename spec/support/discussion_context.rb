shared_context 'discussion' do

  def create_discussion(attrs)
    expect(attrs).to have_key(:canoe_id)
    visit new_canoe_discussion_path(canoe_id: attrs[:canoe_id]) 
    fill_in 'Subject', with: attrs[:subject] if attrs.has_key? :subject
    click_button '저장'
  end

  def discussion_should_be_created(attrs)
    expect(Discussion.last_created).to_not be_nil
    discussion = Discussion.find Discussion.last_created.id
    if attrs.has_key? :user
      user = attrs.delete(:user)
      expect(user.stringify_keys.to_a - discussion.user.attributes.to_a).to be_empty
    end
    expect(attrs.stringify_keys.to_a - discussion.attributes.to_a).to be_empty
  end

  def go_to_new_discussion_page(canoe_id)
    do_not_follow_redirect do
      visit new_canoe_discussion_path(canoe_id: canoe_id)
    end
  end

end
