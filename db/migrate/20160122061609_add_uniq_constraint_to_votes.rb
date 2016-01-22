class AddUniqConstraintToVotes < ActiveRecord::Migration
  def change
    add_index :votes, [:user_id, :proposal_id, :deleted_at], unique: true
  end
end
