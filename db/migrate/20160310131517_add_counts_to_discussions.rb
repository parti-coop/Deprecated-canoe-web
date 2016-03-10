class AddCountsToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :proposals_count, :integer, default: 0
    add_column :discussions, :opinions_count, :integer, default: 0
  end
end
