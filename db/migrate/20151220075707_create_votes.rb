class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.references :proposal, null: false, index: true
      t.references :user, null: false, index: true
      t.integer :choice, null: false
      t.timestamps null: false
    end
  end
end
