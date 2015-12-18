class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.string :subject, null: false
      t.text :body
      t.references :user, null: false, index: true
      t.references :canoe, null: false, index: true
      t.timestamps null: false
    end
  end
end
