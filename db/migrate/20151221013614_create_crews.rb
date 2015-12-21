class CreateCrews < ActiveRecord::Migration
  def change
    create_table :crews do |t|
      t.references :user, null: false
      t.references :inviter, null: false, index: true
      t.references :canoe, null: false, index: true
      t.timestamps null: false
    end

    add_index :crews, [:user_id, :canoe_id], unique: true
  end
end
