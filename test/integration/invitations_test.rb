require 'test_helper'

class InvitationsTest < ActionDispatch::IntegrationTest
  test 'create and destroy' do
    refute canoes(:canoe1).crew?(users(:two))
    refute canoes(:canoe1).invited?(users(:two))

    sign_in users(:one)
    post canoe_invitations_path(canoe_id: canoes(:canoe1), invitation: { user_key: users(:two).nickname })

    refute canoes(:canoe1).crew?(users(:two))
    assert canoes(:canoe1).invited?(users(:two))

    delete invitation_path(assigns(:invitation))

    refute canoes(:canoe1).crew?(users(:two))
    refute canoes(:canoe1).invited?(users(:two))
  end

  test 'create with anonymous email' do
    refute User.exists?(email: 'anonymous@test.com')

    sign_in users(:one)
    post canoe_invitations_path(canoe_id: canoes(:canoe1), invitation: { user_key: 'anonymous@test.com' })

    anonymous = User.create(nickname: 'anonymous', email: 'anonymous@test.com')
    refute canoes(:canoe1).crew?(anonymous)
    assert canoes(:canoe1).invited?(anonymous)
  end

  test 'accept' do
    refute canoes(:canoe1).crew?(users(:guest))
    assert canoes(:canoe1).invited?(users(:guest))

    sign_in users(:guest)
    post accept_canoe_invitations_path(canoes(:canoe1))

    assert canoes(:canoe1).crew?(users(:guest))
    refute canoes(:canoe1).invited?(users(:guest))
  end

  test 'should not invite a crew' do
    assert canoes(:canoe1).crew?(users(:crew))
    refute canoes(:canoe1).invited?(users(:crew))

    sign_in users(:one)
    post canoe_invitations_path(canoe_id: canoes(:canoe1), invitation: { user_key: users(:crew).nickname })

    assert canoes(:canoe1).crew?(users(:crew))
    refute canoes(:canoe1).invited?(users(:crew))
  end

  test 'guest should not invite a user who request to join' do
    refute canoes(:canoe1).crew?(users(:visitor))
    assert canoes(:canoe1).request_to_join?(users(:visitor))
    refute canoes(:canoe1).invited?(users(:visitor))

    sign_in users(:one)

    previous = canoes(:canoe1).invitations.count

    post canoe_invitations_path(canoe_id: canoes(:canoe1), invitation: { user_key: users(:visitor).nickname })

    assert_equal previous, canoes(:canoe1).reload.invitations.count
  end

  test 'should not invite duplicated' do
    refute canoes(:canoe1).crew?(users(:guest))
    assert canoes(:canoe1).invited?(users(:guest))

    previous_count = canoes(:canoe1).invitations.count

    sign_in users(:one)
    post canoe_invitations_path(canoe_id: canoes(:canoe1), invitation: { user_key: users(:guest).nickname })

    assert_equal previous_count, canoes(:canoe1).invitations.count
  end
end
