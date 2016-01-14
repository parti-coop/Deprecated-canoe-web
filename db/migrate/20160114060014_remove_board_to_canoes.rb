class RemoveBoardToCanoes < ActiveRecord::Migration
  def change
    remove_column :canoes, :board, :text
  end
end
