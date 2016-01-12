require 'test_helper'

class CrewsTest < ActionDispatch::IntegrationTest
  test 'new' do
    assert_equal users(:one), canoes(:canoe1).user

    sign_in users(:one)
    refute canoes(:canoe1).crews.exists? user: users(:two)

    user_key = users(:two).nickname
    post canoe_crews_path(canoe_id: canoes(:canoe1), crew: { user_key: user_key})

    assert canoes(:canoe1).crews.exists? user: users(:two)
  end

  test 'should not add owner' do
    assert_equal users(:one), canoes(:canoe1).user

    sign_in users(:one)

    user_key = users(:one).nickname
    post canoe_crews_path(canoe_id: canoes(:canoe1), crew: { user_key: user_key})

    refute canoes(:canoe1).crews.exists? user: users(:two)
  end

  test 'should not duplicated crew' do
    assert_equal users(:one), canoes(:canoe1).user

    sign_in users(:one)
    refute canoes(:canoe1).crews.exists? user: users(:two)

    user_key = users(:two).nickname
    post canoe_crews_path(canoe_id: canoes(:canoe1), crew: { user_key: user_key})

    origin_count = canoes(:canoe1).crews.count

    post canoe_crews_path(canoe_id: canoes(:canoe1), crew: { user_key: user_key})
    assert_equal origin_count, canoes(:canoe1).crews.count
  end
end
