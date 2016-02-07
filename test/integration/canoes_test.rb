require 'test_helper'

class CanoesTest < ActionDispatch::IntegrationTest
  test 'new' do
    sign_in users(:one)
    post canoes_path, { canoe: { title: 'test', theme: 'theme'} }

    assert_equal users(:one), assigns(:canoe).user
    assert_equal 'test', assigns(:canoe).title
    assert_equal 'theme', assigns(:canoe).theme
  end

  test 'edit by owner' do
    sign_in users(:one)

    title = canoes(:canoe1).title + 'xx'
    put canoe_path(id: canoes(:canoe1).id, canoe: { title: title, theme: 'theme' })

    assert_equal title, assigns(:canoe).title
    assert_equal 'theme', assigns(:canoe).theme
  end

  test 'should not edit a canoe by visitor' do
    sign_in users(:two)

    origin_title = canoes(:canoe1).title
    put canoe_path(id: canoes(:canoe1).id, canoe: { title: origin_title + 'xx'})

    assert_equal origin_title, assigns(:canoe).title
  end

  test 'can edit a canoe by crew' do
    assert canoes(:canoe1).crew?(users(:crew))
    sign_in users(:crew)

    title = canoes(:canoe1).title + 'xxx'
    put canoe_path(id: canoes(:canoe1).id, canoe: { title: title })

    assert_equal title, assigns(:canoe).title
  end

  test 'delete' do
    sign_in users(:one)
    delete canoe_path(id: canoes(:canoe1).id)

    refute Canoe.exists?(canoes(:canoe1).id)
    assert Canoe.with_deleted.exists?(canoes(:canoe1).id)
    assert_redirected_to canoes_path
  end

  test 'should not destroy a canoe by the other' do
    sign_in users(:two)
    delete canoe_path(id: canoes(:canoe1).id)

    assert Canoe.exists?(canoes(:canoe1).id)
  end

  test 'slug' do
    get short_canoe_path(canoes(:canoe1).slug)
    assert_response :success
  end

  test 'to notify when a canoe is destroyed' do
    assert canoes(:canoe1).crew?(users(:crew))

    sign_in users(:one)
    delete canoe_path(id: canoes(:canoe1).id)

    assert_equal users(:crew).mailbox.notifications.first.notified_object_id, assigns(:canoe).id
    assert users(:one).mailbox.notifications.empty?
  end

  test 'invite' do
    sign_in users(:one)
    post canoe_invite_path(canoe_id: canoes(:canoe1), email: 'a@test.com')

    assert_not ActionMailer::Base.deliveries.empty?
    email = ActionMailer::Base.deliveries.first
    assert_equal [users(:one).email], email.from
    assert_equal ['a@test.com'], email.to
  end
end
