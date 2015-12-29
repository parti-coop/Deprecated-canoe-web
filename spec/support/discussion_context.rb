shared_context 'discussion' do

  def discussions_exist(attrs_set)
    attrs_set.map do |attrs|
      FactoryGirl.create(:discussion, attrs)
    end
  end

  def discussions_not_exist(canoe)
    canoe.discussions.destroy_all
  end

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

  def post_to_discussion_url(canoe_id)
    page.driver.browser.post canoe_discussions_path(canoe_id)
  end

  def update_discussion(discussion_id, attrs)
    visit edit_discussion_path discussion_id
    fill_in 'Subject', with: attrs[:subject] if attrs.has_key? :subject
    click_button '저장'
  end

  def discussion_should_be_updated(discussion_id, attrs)
    discussion = Discussion.find discussion_id
    expect(attrs.stringify_keys.to_a - discussion.attributes.to_a).to be_empty
  end

  def go_to_edit_discussion_page(discussion_id)
    do_not_follow_redirect do
      visit edit_discussion_path(discussion_id)
    end
  end

  def put_to_discussion_url(discussion_id, params = {})
    page.driver.browser.put discussion_path(discussion_id), params
  end

  def delete_to_discussion_url(discussion_id)
    page.driver.browser.delete discussion_path(discussion_id)
  end

  def discussion_should_be_deleted(discussion_id)
    expect(Discussion.exists?(discussion_id)).to be false
  end

  def discussion_should_not_be_deleted(discussion_id)
    expect(Discussion.exists?(discussion_id)).to be true
  end

  def user_should_see_discussion_list(canoe_id)
    user_should_see_show_canoe_page(canoe_id)
  end

  def go_to_list_discussion_page(canoe_id)
    visit canoe_path(canoe_id)
  end

  def page_should_have_discussion_list(attrs_set)
    discussion_texts = find_discussion_links(page).map(&:text)
    expect(discussion_texts.length).to eq attrs_set.length
    discussion_texts.zip(attrs_set).each do |text, attrs|
      expecteds = attrs.slice(:subject).values
      expecteds.each do |expected|
        expect(text).to include(expected)
      end
    end
  end

  def page_should_have_empty_discussion_list
    expect(find_discussion_links(page)).to be_empty
  end

  private

  def find_discussion_links(page)
    page.all("a[href]").select do |a|
      a[:href] =~ %r{^/app/discussions/\d+$}
    end
  end
end
