require 'test_helper'

class CanoesTest < ActionDispatch::IntegrationTest
  test 'list' do
    get canoes_path
    refute assigns(:canoes).nil?
  end

  test 'new' do
    sign_in users(:one)
    post canoes_path(canoe: { title: 'test'} )

    assert users(:one), assigns(:canoe).user
    assert 'test', assigns(:canoe).title
  end
end
