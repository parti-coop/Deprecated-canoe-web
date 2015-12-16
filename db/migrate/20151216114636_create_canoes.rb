class CreateCanoes < ActiveRecord::Migration
  def change
    create_table :canoes do |t|
      t.string :title, null: false
      t.references :user, null: false, index: true
      t.timestamps null: false
    end
  end
end
