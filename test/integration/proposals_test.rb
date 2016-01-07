require 'test_helper'

class ProposalTest < ActionDispatch::IntegrationTest
  test 'new' do
    sign_in users(:one)
    post discussion_proposals_path(discussion_id: discussions(:discussion1).id, proposal: { body: 'test' } )

    assert_equal users(:one), assigns(:proposal).user
    assert_equal 'test', assigns(:proposal).body
  end

  test 'shoud not create by visitor' do
    sign_in users(:visitor)
    post discussion_proposals_path(discussion_id: discussions(:discussion1).id, proposal: { body: 'test' } )

    assert_redirected_to root_path
  end

  test 'edit by owner' do
    sign_in users(:one)

    body = proposals(:proposal1).body + 'xx'
    put proposal_path(id: proposals(:proposal1).id, proposal: { body: body})

    assert_equal body, assigns(:proposal).body
  end

  test 'should not edit by the other' do
    sign_in users(:two)

    original_body = proposals(:proposal1).body
    put proposal_path(id: proposals(:proposal1).id, proposal: { body: original_body + 'xx' })

    assert_equal original_body, assigns(:proposal).body
  end

  test 'delete' do
    sign_in users(:one)
    delete proposal_path(id: proposals(:proposal1).id)

    refute Canoe.exists?(proposals(:proposal1).id)
  end
end
