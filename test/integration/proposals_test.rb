require 'test_helper'

class ProposalTest < ActionDispatch::IntegrationTest
  test 'create' do
    sign_in users(:one)
    post discussion_proposals_path(discussion_id: discussions(:discussion1).id, proposal: { body: 'test' } )

    assert_equal users(:one), assigns(:proposal).user
    assert_equal 'test', assigns(:proposal).body
  end

  test 'activity' do
    sign_in users(:one)
    post discussion_proposals_path(discussion_id: discussions(:discussion1).id, proposal: { body: 'test' } )

    activity = discussions(:discussion1).reload.activities.last
    assert_equal 'proposals.create', activity.key
    assert_equal discussions(:discussion1), activity.trackable
    assert_equal assigns(:proposal), activity.recipient
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

  test 'destroy' do
    sign_in users(:one)
    delete proposal_path(id: proposals(:proposal1).id)

    refute Canoe.exists?(proposals(:proposal1).id)
  end

  test 'activity with destroyed' do
    sign_in users(:one)
    post discussion_proposals_path(discussion_id: discussions(:discussion1).id, proposal: { body: 'test' } )

    delete proposal_path(id: assigns(:proposal).id)
    activity = discussions(:discussion1).reload.activities.last
    assert_equal assigns(:proposal).id, activity.recipient_with_deleted.id
    assert_equal 'proposals.destroy', activity.key
  end

  test 'sequential_id' do
    sign_in users(:one)
    post discussion_proposals_path(discussion_id: discussions(:discussion1).id, proposal: { body: 'test1' } )
    previous_sequential_id = assigns(:proposal).sequential_id

    post discussion_proposals_path(discussion_id: discussions(:discussion1).id, proposal: { body: 'test2' } )
    assert_equal previous_sequential_id + 1, assigns(:proposal).sequential_id

    delete proposal_path(id: assigns(:proposal).id)
    post discussion_proposals_path(discussion_id: discussions(:discussion1).id, proposal: { body: 'test3' } )
    assert_equal previous_sequential_id + 2, assigns(:proposal).sequential_id
  end
end
