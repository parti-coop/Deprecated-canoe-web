require 'test_helper'

class RequestToJoinsTest < ActionDispatch::IntegrationTest
  test 'ask' do
    refute canoes(:canoe1).crew?(users(:two))
    refute canoes(:canoe1).request_to_join?(users(:two))

    sign_in users(:two)

    post ask_canoe_request_to_joins_path(canoe_id: canoes(:canoe1))

    refute canoes(:canoe1).crew?(users(:two))
    assert canoes(:canoe1).request_to_join?(users(:two))
  end

  test 'no duplicated ask' do
    refute canoes(:canoe1).crew?(users(:two))
    refute canoes(:canoe1).request_to_join?(users(:two))

    sign_in users(:two)

    post ask_canoe_request_to_joins_path(canoe_id: canoes(:canoe1))

    previous = canoes(:canoe1).request_to_joins.count

    post ask_canoe_request_to_joins_path(canoe_id: canoes(:canoe1))

    assert_equal previous, canoes(:canoe1).reload.request_to_joins.count
  end

  test 'should not ask to private_join canoe' do
    canoes(:canoe1).how_to_join = 'private_join'
    canoes(:canoe1).save!

    refute canoes(:canoe1).crew?(users(:two))
    refute canoes(:canoe1).request_to_join?(users(:two))

    sign_in users(:two)

    post ask_canoe_request_to_joins_path(canoe_id: canoes(:canoe1))

    refute canoes(:canoe1).crew?(users(:two))
    refute canoes(:canoe1).request_to_join?(users(:two))
  end

  test 'accept' do
    refute canoes(:canoe1).crew?(users(:visitor))
    assert canoes(:canoe1).request_to_join?(users(:visitor))

    sign_in users(:one)

    post accept_canoe_request_to_join_path(canoe_id: canoes(:canoe1), id: request_to_joins(:req1))

    canoes(:canoe1).reload
    assert canoes(:canoe1).crew?(users(:visitor))
    refute canoes(:canoe1).request_to_join?(users(:visitor))
  end

  test 'should not duplicated crew even if she is already crew' do
    assert_equal users(:one), canoes(:canoe1).user
    assert canoes(:canoe1).request_to_join?(users(:visitor))
    sign_in users(:one)

    crew = canoes(:canoe1).crews.build
    crew.user = users(:visitor)
    crew.inviter = canoes(:canoe1).user
    crew.save

    assert canoes(:canoe1).crew?(users(:visitor))

    sign_in users(:one)

    post accept_canoe_request_to_join_path(canoe_id: canoes(:canoe1), id: request_to_joins(:req1))

    canoes(:canoe1).reload
    assert canoes(:canoe1).crew?(users(:visitor))
    refute canoes(:canoe1).request_to_join?(users(:visitor))
  end

  test 'notification for asking' do
    assert canoes(:canoe1).crew?(users(:one))
    assert canoes(:canoe1).crew?(users(:crew))
    refute canoes(:canoe1).crew?(users(:two))
    refute canoes(:canoe1).request_to_join?(users(:two))

    sign_in users(:two)

    post ask_canoe_request_to_joins_path(canoe_id: canoes(:canoe1))

    assert_equal users(:crew).mailbox.notifications.first.notified_object, assigns(:request_to_join)
    assert_equal users(:one).mailbox.notifications.first.notified_object, assigns(:request_to_join)
    assert users(:two).mailbox.notifications.empty?
  end

  test 'notification for accept' do
    assert canoes(:canoe1).crew?(users(:one))
    assert canoes(:canoe1).crew?(users(:crew))
    refute canoes(:canoe1).crew?(users(:visitor))
    assert canoes(:canoe1).request_to_join?(users(:visitor))

    sign_in users(:one)

    post accept_canoe_request_to_join_path(canoe_id: canoes(:canoe1), id: request_to_joins(:req1))

    assert_equal users(:crew).mailbox.notifications.first.notified_object_id, assigns(:request_to_join).id
    assert users(:one).mailbox.notifications.empty?
    assert_equal users(:visitor).mailbox.notifications.first.notified_object_id, assigns(:request_to_join).id

    refute_equal users(:crew).mailbox.notifications.first, users(:visitor).mailbox.notifications.first
  end
end
