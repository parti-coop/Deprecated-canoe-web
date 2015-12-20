class CreateProposals < ActiveRecord::Migration
  def change
    create_table :proposals do |t|
      t.text :body
      t.references :discussion, null: false, index: true
      t.references :user, null: false, index: true
      t.timestamps null: false
    end
  end
end
