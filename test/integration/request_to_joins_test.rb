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

  test 'accept' do
    refute canoes(:canoe1).crew?(users(:visitor))
    assert canoes(:canoe1).request_to_join?(users(:visitor))

    sign_in users(:one)

    post accept_canoe_request_to_join_path(canoe_id: canoes(:canoe1), id: request_to_joins(:req1))

    canoes(:canoe1).reload
    assert canoes(:canoe1).crew?(users(:visitor))
    refute canoes(:canoe1).request_to_join?(users(:visitor))
  end
end
