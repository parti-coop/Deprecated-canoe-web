class AddCountsToCanoes < ActiveRecord::Migration
  def change
    add_column :canoes, :crews_count, :integer, default: 0
    add_column :canoes, :discussions_count, :integer, default: 0
    add_column :canoes, :opinions_count, :integer, default: 0
  end
end
