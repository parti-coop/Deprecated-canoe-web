class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :user
      t.string :email, null: false
      t.references :host, null: false
      t.references :canoe, null: false, index: true
      t.timestamps null: false
    end

    add_index :invitations, [:user_id, :canoe_id], unique: true
  end
end
