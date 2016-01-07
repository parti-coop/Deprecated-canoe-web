require 'test_helper'

class OpinionsTest < ActionDispatch::IntegrationTest
  test 'new' do
    previous_discussed_at = discussions(:discussion1).discussed_at
    sign_in users(:one)
    post discussion_opinions_path(discussion_id: discussions(:discussion1).id, opinion: { body: 'test' } )

    assert_equal users(:one), assigns(:opinion).user
    assert_equal 'test', assigns(:opinion).body
    refute_equal previous_discussed_at, discussions(:discussion1).reload.discussed_at
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

  test 'delete' do
    sign_in users(:one)
    delete opinion_path(id: opinions(:opinion1).id)

    refute Canoe.exists?(opinions(:opinion1).id)
  end

  test 'mention' do
    sign_in users(:one)
    post discussion_opinions_path(discussion_id: discussions(:discussion1).id, opinion: { body: "test @#{users('two').nickname}" } )
    assert_equal users(:two), assigns(:opinion).mentions.first.user

    put opinion_path(id: opinions(:opinion1).id, opinion: { body: "test @#{users('crew').nickname}"})
    assert_equal users(:crew), assigns(:opinion).mentions.first.user
    assert_equal 1, assigns(:opinion).mentions.count

    put opinion_path(id: opinions(:opinion1).id, opinion: { body: "test @#{users('visitor').nickname}"})
    assert_equal users(:visitor), assigns(:opinion).mentions.first.user
    assert_equal 1, assigns(:opinion).mentions.count

    put opinion_path(id: opinions(:opinion1).id, opinion: { body: body})
    assert assigns(:opinion).mentions.empty?
  end
end
