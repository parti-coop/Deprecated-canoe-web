require 'rails_helper'

feature 'Canoe' do
  include_context 'auth'
  include_context 'canoe'

  scenario 'Create new canoe by valid user' do
    sign_in_as 'valid-user@email.com'
    create_canoe title: 'Canoe created by scenario'
    canoe_should_be_created(
      title: 'Canoe created by scenario',
      user: { email: 'valid-user@email.com' }
    )
  end

  scenario 'List one canoe' do
    set_all_canoes ( [ title: 'The only canoe' ] )
    go_to_list_canoe_page
    page_should_have_canoe_list( [ title: 'The only canoe' ] )
  end

  def set_all_canoes(attrs_set)
    Canoe.delete_all
    DatabaseCleaner.clean
    attrs_set.each do |attrs|
      FactoryGirl.create(:canoe, attrs)
    end
  end

  def go_to_list_canoe_page
    visit canoes_path
  end

  def page_should_have_canoe_list(attrs_set)
    canoe_links = page.all("a[href]").select { |a|
      a[:href] =~ /#{Regexp.quote(canoes_path + '/')}\d+/
    }
    canoe_titles = canoe_links.map(&:text)
    expect(canoe_titles).to eq(['The only canoe'])
  end

end
