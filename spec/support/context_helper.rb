shared_context 'helper' do

  def do_not_follow_redirect &block
    begin
      options = page.driver.instance_variable_get(:@options)
      prev_value = options[:follow_redirects]
      options[:follow_redirects] = false
      yield
    ensure
      options[:follow_redirects] = prev_value
    end
  end

end
