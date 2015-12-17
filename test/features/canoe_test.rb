require 'test_helper'

feature 'Canoe' do
  scenario 'the test is sound' do
    visit root_path
    page.must_have_content 'canoe'
    page.wont_have_content 'not-exist-content'
  end
end
