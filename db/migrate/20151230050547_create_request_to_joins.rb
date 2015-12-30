class CreateRequestToJoins < ActiveRecord::Migration
  def change
    create_table :request_to_joins do |t|
      t.references :user, null: false
      t.references :canoe, null: false, index: true
      t.timestamps null: false
    end

    add_index :request_to_joins, [:user_id, :canoe_id], unique: true
  end
end
