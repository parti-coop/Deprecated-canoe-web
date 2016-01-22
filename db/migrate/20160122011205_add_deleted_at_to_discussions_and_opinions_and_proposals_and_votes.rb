class AddDeletedAtToDiscussionsAndOpinionsAndProposalsAndVotes < ActiveRecord::Migration
  def change
    add_column :discussions, :deleted_at, :datetime
    add_index :discussions, :deleted_at
    add_column :opinions, :deleted_at, :datetime
    add_index :opinions, :deleted_at
    add_column :proposals, :deleted_at, :datetime
    add_index :proposals, :deleted_at
    add_column :votes, :deleted_at, :datetime
    add_index :votes, :deleted_at
  end
end
