class AddVotesCountToProposals < ActiveRecord::Migration
  def change
    add_column :proposals, :in_favor_votes_count, :integer, null: false, default: 0
    add_column :proposals, :opposed_votes_count, :integer, null: false, default: 0

    reversible do |dir|
      dir.up do
        Vote.counter_culture_fix_counts
      end
    end
  end
end
