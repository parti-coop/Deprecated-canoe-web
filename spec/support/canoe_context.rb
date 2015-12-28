shared_context 'canoe' do
  include_context 'helper'

  def canoes_exist(attrs_set)
    attrs_set.map do |attrs|
      FactoryGirl.create(:canoe, attrs)
    end
  end

  def canoes_not_exist
    Canoe.delete_all
  end

  def create_canoe(attrs)
    visit new_canoe_path
    fill_in 'Title', with: attrs[:title] if attrs.has_key? :title
    fill_in 'Slug', with: attrs[:slug] if attrs.has_key? :slug
    click_button '저장'
  end

  def canoe_should_be_created(attrs)
    expect(Canoe.last_created).to_not be_nil
    canoe = Canoe.find Canoe.last_created.id
    if attrs.has_key? :user
      user = attrs.delete(:user)
      expect(user.stringify_keys.to_a - canoe.user.attributes.to_a).to be_empty
    end
    expect(attrs.stringify_keys.to_a - canoe.attributes.to_a).to be_empty
  end

  def update_canoe(canoe_id, attrs)
    visit edit_canoe_path canoe_id
    fill_in 'Title', with: attrs[:title] if attrs.has_key? :title
    fill_in 'Slug', with: attrs[:slug] if attrs.has_key? :slug
    click_button '저장'
  end

  def canoe_should_be_updated(canoe_id, attrs)
    canoe = Canoe.find canoe_id
    expect(attrs.stringify_keys.to_a - canoe.attributes.to_a).to be_empty
  end

  def go_to_list_canoe_page
    do_not_follow_redirect do
      visit canoes_path
    end
  end

  def post_to_create_canoe_url
    page.driver.browser.post canoes_path
  end

  def go_to_new_canoe_page
    do_not_follow_redirect do
      visit new_canoe_path
    end
  end

  def page_should_have_canoe_list(attrs_set)
    canoe_texts = find_canoe_links(page).map(&:text)
    expect(canoe_texts.length).to eq attrs_set.length
    canoe_texts.zip(attrs_set).each do |text, attrs|
      expecteds = attrs.slice(:title).values
      expecteds.each do |expected|
        expect(text).to include(expected)
      end
    end
  end

  def page_should_have_empty_canoe_list
    expect(find_canoe_links(page)).to be_empty
  end

  private

  def find_canoe_links(page)
    page.all("a[href]").select do |a|
      a[:href] =~ %r{^/([^/]+)$} && Canoe.exists?(slug: $1)
    end
  end

end
