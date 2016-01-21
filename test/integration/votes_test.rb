require 'test_helper'

class VotesTest < ActionDispatch::IntegrationTest
  test 'in_favor' do
    refute proposals(:proposal1).voted_by?(users(:one), :in_favor)

    sign_in users(:one)
    post in_favor_proposal_path(id: proposals(:proposal1).id)

    assert proposals(:proposal1).voted_by?(users(:one), :in_favor)
  end

  test 'opposed' do
    refute proposals(:proposal1).voted_by?(users(:one), :opposed)

    sign_in users(:one)
    post opposed_proposal_path(id: proposals(:proposal1).id)

    assert proposals(:proposal1).voted_by?(users(:one), :opposed)
  end

  test 'in_favor_after_opposed' do
    sign_in users(:one)

    post opposed_proposal_path(id: proposals(:proposal1).id)
    assert proposals(:proposal1).voted_by?(users(:one), :opposed)

    post in_favor_proposal_path(id: proposals(:proposal1).id)
    proposals(:proposal1).reload
    assert proposals(:proposal1).voted_by?(users(:one), :in_favor)
  end

  test 'unvote' do
    sign_in users(:one)

    post opposed_proposal_path(id: proposals(:proposal1).id)
    assert proposals(:proposal1).voted_by?(users(:one), :opposed)

    delete unvote_proposal_path(id: proposals(:proposal1).id)
    proposals(:proposal1).reload
    refute proposals(:proposal1).voted_by?(users(:one))
  end

  test 'activity of in_favor' do
    sign_in users(:one)
    post in_favor_proposal_path(id: proposals(:proposal1).id)
    activity = proposals(:proposal1).discussion.activities.last
    assert_equal 'votes.in_favor', activity.key
  end

  test 'activity of opposed' do
    sign_in users(:one)
    post opposed_proposal_path(id: proposals(:proposal1).id)
    activity = proposals(:proposal1).discussion.activities.last
    assert_equal 'votes.opposed', activity.key
  end
end
