require 'test_helper'

class DiscussionsTest < ActionDispatch::IntegrationTest
  test 'new' do
    sign_in users(:one)
    opinions_attributes = { body: 'test body' }
    post canoe_discussions_path(canoe_id: canoes(:canoe1).id, discussion: { subject: 'test', opinions_attributes: {'0': opinions_attributes}} )

    assert_equal users(:one), assigns(:discussion).user
    assert_equal 'test', assigns(:discussion).subject
    assert_equal users(:one), assigns(:discussion).opinions.first.user
    assert_equal 'test body', assigns(:discussion).opinions.first.body
  end

  test 'shoud not create by visitor' do
    sign_in users(:visitor)
    post canoe_discussions_path(canoe_id: canoes(:canoe1).id, discussion: { subject: 'test' } )

    assert_redirected_to root_path
  end

  test 'edit by owner' do
    sign_in users(:one)

    subject = discussions(:discussion1).subject + 'xx'
    put discussion_path(id: discussions(:discussion1).id, discussion: { subject: subject })

    assert_equal subject, assigns(:discussion).subject
  end

  test 'can edit by crew' do
    assert canoes(:canoe1).crew?(users(:crew))
    sign_in users(:crew)

    subject = discussions(:discussion1).subject + 'xx'
    put discussion_path(id: discussions(:discussion1).id, discussion: { subject: subject })

    assert_equal subject, assigns(:discussion).subject
  end

  test 'should not edit by the other' do
    sign_in users(:two)

    original_subject = discussions(:discussion1).subject
    put discussion_path(id: discussions(:discussion1).id, discussion: { subject: discussions(:discussion1).subject + 'xx' })

    assert_equal original_subject, assigns(:discussion).subject
  end

  test 'delete' do
    sign_in users(:one)
    delete discussion_path(id: discussions(:discussion1).id)

    refute Canoe.exists?(discussions(:discussion1).id)
  end

  test 'to notify when a disscussion is created' do
    assert canoes(:canoe1).crew?(users(:crew))

    sign_in users(:one)
    post canoe_discussions_path(canoe_id: canoes(:canoe1).id, discussion: { subject: 'test' } )
    assert_equal users(:crew).mailbox.notifications.first.notified_object, assigns(:discussion)
    assert users(:one).mailbox.notifications.empty?
  end

  test 'to notify when a disscussion is destroyed' do
    assert canoes(:canoe1).crew?(users(:crew))

    sign_in users(:one)

    delete discussion_path(id: discussions(:discussion1).id)
    assert_equal users(:crew).mailbox.notifications.first.notified_object_id, assigns(:discussion).id
    assert users(:one).mailbox.notifications.empty?
  end
end
