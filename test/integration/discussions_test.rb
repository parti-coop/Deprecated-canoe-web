require 'test_helper'

class DiscussionsTest < ActionDispatch::IntegrationTest
  test 'create' do
    sign_in users(:one)
    opinions_attributes = { body: 'test body' }
    post canoe_discussions_path(canoe_id: canoes(:canoe1).id, discussion: { subject: 'test', opinions_attributes: {'0': opinions_attributes}} )

    assert_equal users(:one), assigns(:discussion).user
    assert_equal 'test', assigns(:discussion).subject
    assert_equal users(:one), assigns(:discussion).opinions.first.user
    assert_equal 'test body', assigns(:discussion).opinions.first.body
  end

  test 'create with blank opinion' do
    sign_in users(:one)
    opinions_attributes = { body: '' }
    post canoe_discussions_path(canoe_id: canoes(:canoe1).id, discussion: { subject: 'test', opinions_attributes: {'0': opinions_attributes}} )

    assert assigns(:discussion).opinions.empty?
  end

  test 'activity' do
    sign_in users(:one)
    opinions_attributes = { body: 'test body' }
    post canoe_discussions_path(canoe_id: canoes(:canoe1).id, discussion: { subject: 'test', opinions_attributes: {'0': opinions_attributes}} )

    activity = assigns(:discussion).reload.activities.first
    assert_equal 'opinion', activity.key
    assert_equal 'create', activity.task
    assert_equal assigns(:discussion), activity.trackable
    assert_equal assigns(:discussion).opinions.first, activity.subject
  end

  test 'shoud not create by visitor' do
    sign_in users(:visitor)
    post canoe_discussions_path(canoe_id: canoes(:canoe1).id, discussion: { subject: 'test' })

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

  test 'destroy' do
    sign_in users(:one)
    delete discussion_path(id: discussions(:discussion1).id)

    refute Canoe.exists?(discussions(:discussion1).id)
  end

  test 'activity with destroyed discussion' do
    sign_in users(:one)
    opinions_attributes = { body: 'test body' }
    post canoe_discussions_path(canoe_id: canoes(:canoe1).id, discussion: { subject: 'test', opinions_attributes: {'0': opinions_attributes}} )

    activity = assigns(:discussion).reload.activities.first
    assert_equal 'opinion', activity.key
    assert_equal 'create', activity.task

    delete discussion_path(id: assigns(:discussion).id)

    activity.reload
    assert_equal assigns(:discussion), activity.trackable_with_deleted
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

  test 'edit subject and do not create activity' do
    sign_in users(:one)

    previous_last_activity = discussions(:discussion1).activities.last
    put discussion_path(id: discussions(:discussion1).id, discussion: { subject: 'test' })

    activity = assigns(:discussion).reload.activities.last
    assert_equal previous_last_activity, activity
  end

  test 'edit decision and create activity' do
    sign_in users(:one)

    decision = discussions(:discussion1).decision + 'xx'
    put discussion_path(id: discussions(:discussion1).id, discussion: { decision: decision })

    activity = assigns(:discussion).reload.activities.last
    assert_equal 'discussion.decision', activity.key
    assert_equal 'update', activity.task
    assert_equal assigns(:discussion), activity.trackable
    assert_equal assigns(:discussion), activity.subject
  end

  test 'edit decision and create a activity only once' do
    sign_in users(:one)

    decision = discussions(:discussion1).decision + 'xx'
    put discussion_path(id: discussions(:discussion1).id, discussion: { decision: decision })

    previous_count = assigns(:discussion).reload.activities_merged.count
    put discussion_path(id: discussions(:discussion1).id, discussion: { decision: decision })

    assert_equal previous_count, assigns(:discussion).reload.activities_merged.count
  end
end
