require 'test_helper'

class OpinionsTest < ActionDispatch::IntegrationTest
  test 'new' do
    sign_in users(:one)
    post discussion_opinions_path(discussion_id: discussions(:discussion1).id, opinion: { body: 'test' } )

    assert_equal users(:one), assigns(:opinion).user
    assert_equal 'test', assigns(:opinion).body
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

  test 'pin' do
    refute opinions(:opinion1).pinned

    sign_in users(:one)

    patch pin_opinion_path(opinions(:opinion1))
    assert assigns(:opinion).pinned

    patch unpin_opinion_path(opinions(:opinion1))
    refute assigns(:opinion).pinned
  end
end
