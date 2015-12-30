class AddBoardToCanoes < ActiveRecord::Migration
  def change
    add_column :canoes, :board, :text
  end
end
