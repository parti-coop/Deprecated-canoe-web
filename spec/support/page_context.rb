shared_context 'page' do

  def go_to_list_canoe_page
    visit canoes_path
  end

  def page_should_have_canoe_list(attrs_set)
    canoe_titles = find_canoe_links(page).map(&:text)
    expect(canoe_titles).to eq(['The only canoe'])
  end

  def page_should_have_empty_canoe_list
    expect(find_canoe_links(page)).to be_empty
  end

  private

  def find_canoe_links(page)
    page.all("a[href]").select { |a|
      a[:href] =~ /#{Regexp.quote(canoes_path + '/')}\d+/
    }
  end

end
