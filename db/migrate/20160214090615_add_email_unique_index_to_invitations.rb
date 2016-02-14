class AddEmailUniqueIndexToInvitations < ActiveRecord::Migration
  def change
    add_index :invitations, [:email, :canoe_id], unique: true
  end
end
