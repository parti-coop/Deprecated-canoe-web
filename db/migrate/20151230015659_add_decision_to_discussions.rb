class AddDecisionToDiscussions < ActiveRecord::Migration
  def change
    add_column :discussions, :decision, :text
  end
end
