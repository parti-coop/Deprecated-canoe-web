require 'rails_helper'

feature 'Canoe' do

  scenario 'Create new canoe' do
    visit new_canoe_path
    expect(page).to have_content 'canoe'
  end

end
