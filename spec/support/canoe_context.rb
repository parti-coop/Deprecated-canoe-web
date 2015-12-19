shared_context 'canoe' do

  def create_canoe(attrs)
    visit new_canoe_path
    fill_in 'Title', with: attrs[:title] if attrs.has_key? :title
    click_button '저장'
  end

  def canoe_should_be_created(attrs)
    canoe = Canoe.find Canoe.last_created.id
    if attrs.has_key? :user
      user = attrs.delete(:user)
      expect(user.stringify_keys.to_a - canoe.user.attributes.to_a).to be_empty
    end
    expect(attrs.stringify_keys.to_a - canoe.attributes.to_a).to be_empty
  end

end
