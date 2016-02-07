require 'test_helper'

class CrewsTest < ActionDispatch::IntegrationTest
  test 'crew getting off' do
    assert canoes(:canoe1).crew?(users(:crew))

    sign_in users(:crew)
    delete canoe_crews_me_path(canoe_id: canoes(:canoe1).id)

    refute canoes(:canoe1).crew?(users(:crew))
  end

  test 'captain should not get off' do
    assert canoes(:canoe1).captain?(users(:one))
    assert canoes(:canoe1).crew?(users(:one))

    sign_in users(:one)
    delete canoe_crews_me_path(canoe_id: canoes(:canoe1).id)

    assert canoes(:canoe1).crew?(users(:one))
  end
end
