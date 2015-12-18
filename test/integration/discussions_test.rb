require 'test_helper'

class DiscussionsTest < ActionDispatch::IntegrationTest
  test 'new' do
    sign_in users(:one)
    post canoe_discussions_path(canoe_id: canoes(:canoe1).id, discussion: { subject: 'test', body: 'test body'} )

    assert_equal users(:one), assigns(:discussion).user
    assert_equal 'test', assigns(:discussion).subject
  end

  test 'edit by owner' do
    sign_in users(:one)

    subject = discussions(:discussion1).subject + 'xx'
    put discussion_path(id: discussions(:discussion1).id, discussion: { subject: subject, body: 'new body'})

    assert_equal subject, assigns(:discussion).subject
  end

  test 'should not edit by the other' do
    sign_in users(:two)

    original_subject = discussions(:discussion1).subject
    put discussion_path(id: discussions(:discussion1).id, discussion: { subject: discussions(:discussion1).subject + 'xx', body: 'new body'})

    assert_equal original_subject, assigns(:discussion).subject
  end

  test 'delete' do
    sign_in users(:one)
    delete discussion_path(id: discussions(:discussion1).id)

    refute Canoe.exists?(discussions(:discussion1).id)
  end
end
