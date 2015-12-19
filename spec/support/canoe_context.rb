shared_context 'canoe' do

  def create_canoe_titled(title)
    visit new_canoe_path
    fill_in 'Title', with: title
    click_button '저장'
  end

  def canoe_should_be_created(attrs)
    canoe = Canoe.find Canoe.last_created.id
    expect(attrs.stringify_keys.to_a - canoe.attributes.to_a).to be_empty
  end

end
