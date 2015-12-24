shared_context 'page' do

  def go_to_list_canoe_page
    visit canoes_path
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
    page.all("a[href]").select { |a|
      a[:href] =~ %r{^/([^/]+)$} && Canoe.exists?(slug: $1)
    }
  end

end
