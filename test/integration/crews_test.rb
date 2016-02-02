require 'test_helper'

class CrewsTest < ActionDispatch::IntegrationTest
  test 'crew getting off' do
    assert canoes(:canoe1).crew?(users(:crew))

    sign_in users(:crew)
    delete canoe_crews_me_path(canoe_id: canoes(:canoe1).id)

    refute canoes(:canoe1).crew?(users(:crew))
  end

  test 'captain should not get off' do
    assert canoes(:canoe1).captain?(users(:one))
    assert canoes(:canoe1).crew?(users(:one))

    sign_in users(:one)
    delete canoe_crews_me_path(canoe_id: canoes(:canoe1).id)

    assert canoes(:canoe1).crew?(users(:one))
  end

  test 'create' do
    canoes(:canoe1).how_to_join = 'private_join'
    canoes(:canoe1).save!

    assert canoes(:canoe1).crew? users(:one)

    sign_in users(:one)
    refute canoes(:canoe1).crew? users(:two)

    user_key = users(:two).nickname
    post canoe_crews_path(canoe_id: canoes(:canoe1), crew: { user_key: user_key})

    assert canoes(:canoe1).crew? users(:two)
  end

  test 'should not create crew of public_join canoe' do
    assert canoes(:canoe1).crew? users(:one)

    sign_in users(:one)
    refute canoes(:canoe1).crew? users(:two)

    user_key = users(:two).nickname
    post canoe_crews_path(canoe_id: canoes(:canoe1), crew: { user_key: user_key})

    refute canoes(:canoe1).crew? users(:two)
  end

  test 'remove request_to_join of new crew' do
    canoes(:canoe1).how_to_join = 'private_join'
    canoes(:canoe1).save!

    assert canoes(:canoe1).request_to_join?(users(:visitor))

    assert canoes(:canoe1).crew? users(:one)

    sign_in users(:one)
    refute canoes(:canoe1).crew? users(:visitor)

    user_key = users(:visitor).nickname
    post canoe_crews_path(canoe_id: canoes(:canoe1), crew: { user_key: user_key})

    refute canoes(:canoe1).request_to_join?(users(:visitor))
  end

  test 'should not add owner' do
    canoes(:canoe1).how_to_join = 'private_join'
    canoes(:canoe1).save!

    assert users(:one), canoes(:canoe1).user

    sign_in users(:one)

    user_key = users(:one).nickname
    post canoe_crews_path(canoe_id: canoes(:canoe1), crew: { user_key: user_key})

    refute canoes(:canoe1).crew? users(:two)
  end

  test 'should not duplicated crew' do
    canoes(:canoe1).how_to_join = 'private_join'
    canoes(:canoe1).save!

    assert users(:one), canoes(:canoe1).user

    sign_in users(:one)
    refute canoes(:canoe1).crew? users(:two)

    user_key = users(:two).nickname
    post canoe_crews_path(canoe_id: canoes(:canoe1), crew: { user_key: user_key})

    origin_count = canoes(:canoe1).crews.count

    post canoe_crews_path(canoe_id: canoes(:canoe1), crew: { user_key: user_key})
    assert_equal origin_count, canoes(:canoe1).crews.count
  end
end
