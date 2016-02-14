require 'test_helper'

class OpinionsTest < ActionDispatch::IntegrationTest
  test 'create' do
    previous_discussed_at = discussions(:discussion1).discussed_at
    previous_sailed_at = discussions(:discussion1).canoe.sailed_at
    sign_in users(:one)
    post discussion_opinions_path(discussion_id: discussions(:discussion1).id, opinion: { body: 'test' } )

    assert_equal users(:one), assigns(:opinion).user
    assert_equal 'test', assigns(:opinion).body
    refute_equal previous_discussed_at, discussions(:discussion1).reload.discussed_at
    refute_equal previous_sailed_at, discussions(:discussion1).canoe.reload.sailed_at
  end

  test 'activity' do
    previous_discussed_at = discussions(:discussion1).discussed_at
    sign_in users(:one)
    post discussion_opinions_path(discussion_id: discussions(:discussion1).id, opinion: { body: 'test' } )

    activity = discussions(:discussion1).activities.first
    assert_equal 'opinion', activity.key
    assert_equal 'create', activity.task
  end

  test 'shoud not create by visitor' do
    sign_in users(:visitor)
    post discussion_opinions_path(discussion_id: discussions(:discussion1).id, opinion: { body: 'test' } )

    assert_redirected_to root_path
  end

  test 'edit by owner' do
    sign_in users(:one)

    body = opinions(:opinion1).body + 'xx'
    put opinion_path(id: opinions(:opinion1).id, opinion: { body: body})

    assert_equal body, assigns(:opinion).body
  end

  test 'should not edit by the other' do
    sign_in users(:two)

    original_body = opinions(:opinion1).body
    put opinion_path(id: opinions(:opinion1).id, opinion: { body: original_body + 'xx' })

    assert_equal original_body, assigns(:opinion).body
  end

  test 'destroy' do
    sign_in users(:one)
    delete opinion_path(id: opinions(:opinion1).id)

    refute Canoe.exists?(opinions(:opinion1).id)
  end

  test 'remove activity for destroyed opinion' do
    previous_discussed_at = discussions(:discussion1).discussed_at
    sign_in users(:one)
    post discussion_opinions_path(discussion_id: discussions(:discussion1).id, opinion: { body: 'test' } )

    activity = discussions(:discussion1).reload.activities.last
    delete opinion_path(id: assigns(:opinion).id)
    refute discussions(:discussion1).activities.exists? activity.id
  end

  test 'mention' do
    sign_in users(:one)
    post discussion_opinions_path(discussion_id: discussions(:discussion1).id, opinion: { body: "test @#{users('two').nickname}" } )
    assert_equal users(:two), assigns(:opinion).mentions.first.user

    assert_equal users(:two).mailbox.notifications.first.notified_object_id, assigns(:opinion).mentions.first.id
    assert users(:one).mailbox.notifications.empty?

    put opinion_path(id: opinions(:opinion1).id, opinion: { body: "test @#{users('crew').nickname}"})
    assert_equal users(:crew), assigns(:opinion).mentions.first.user
    assert_equal 1, assigns(:opinion).mentions.count

    assert_equal users(:crew).mailbox.notifications.first.notified_object_id, assigns(:opinion).mentions.first.id
    assert users(:one).mailbox.notifications.empty?

    put opinion_path(id: opinions(:opinion1).id, opinion: { body: "test @#{users('visitor').nickname}"})
    assert_equal users(:visitor), assigns(:opinion).mentions.first.user
    assert_equal 1, assigns(:opinion).mentions.count

    assert_equal users(:visitor).mailbox.notifications.first.notified_object_id, assigns(:opinion).mentions.first.id
    assert users(:one).mailbox.notifications.empty?

    put opinion_path(id: opinions(:opinion1).id, opinion: { body: body})
    assert assigns(:opinion).mentions.empty?
  end

  test 'crew mention' do
    sign_in users(:one)
    post discussion_opinions_path(discussion_id: discussions(:discussion1).id, opinion: { body: "test @crew" } )

    assert_equal users(:crew), assigns(:opinion).mentions.first.user
  end
end
