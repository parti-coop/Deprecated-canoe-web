class AddDeletedAtToCanoes < ActiveRecord::Migration
  def change
    add_column :canoes, :deleted_at, :datetime
    add_index :canoes, :deleted_at
  end
end
