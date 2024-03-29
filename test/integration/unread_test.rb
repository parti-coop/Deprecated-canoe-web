require 'test_helper'

class UnreadTest < ActionDispatch::IntegrationTest
  test 'unread discussion' do
    sign_in users(:one)
    post discussion_opinions_path(discussion_id: discussions(:discussion1).id, opinion: { body: 'test' } )

    assert discussions(:discussion1).unread?(users(:one))
    assert discussions(:discussion1).unread?(users(:crew))

    get_via_redirect discussion_path(discussions(:discussion1))

    refute discussions(:discussion1).unread?(users(:one))
    assert discussions(:discussion1).unread?(users(:crew))
  end
end
