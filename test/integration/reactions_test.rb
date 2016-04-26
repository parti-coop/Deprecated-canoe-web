require 'test_helper'

class ReactionsTest < ActionDispatch::IntegrationTest
  test 'new' do
    sign_in users(:one)
    post reactions_path(reaction: { opinion_id: opinions(:opinion1), token: :'smile' })
    assert_equal assigns(:reaction).user, users(:one)
    assert_equal 'smile', assigns(:reaction).token

    sign_out
    sign_in users(:two)
    post reactions_path(reaction: { opinion_id: opinions(:opinion1), token: :'smile' })
    assert_equal assigns(:reaction).user, users(:two)
    assert_equal 'smile', assigns(:reaction).token
  end

  test 'destroy' do
    sign_in users(:one)
    post reactions_path(reaction: { opinion_id: opinions(:opinion1), token: :'smile' })
    delete reaction_path(id: assigns(:reaction).id)

    refute Reaction.exists? assigns(:reaction).id
  end

  test 'count' do
    sign_in users(:one)
    post reactions_path(reaction: { opinion_id: opinions(:opinion1), token: :'smile' })
    assert_equal 1, opinions(:opinion1).reactions.by_token('smile').count

    post reactions_path(reaction: { opinion_id: opinions(:opinion1), token: :'smile' })
    assert_equal 1, opinions(:opinion1).reactions.by_token('smile').count
  end
end
