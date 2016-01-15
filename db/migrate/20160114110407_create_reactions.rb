class CreateReactions < ActiveRecord::Migration
  def change
    create_table :reactions do |t|
      t.references :user, null: false, index: true
      t.references :opinion, null: false, index: true
      t.string :token, null: false
    end

    add_index :reactions, [:opinion_id, :token, :user_id], unique: true
  end
end
