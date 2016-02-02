class AddHowToJoinToCanoes < ActiveRecord::Migration
  def change
    add_column :canoes, :how_to_join, :string, null: false, default: 'public_join'
  end
end
