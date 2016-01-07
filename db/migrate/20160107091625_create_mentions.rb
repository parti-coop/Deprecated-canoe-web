class CreateMentions < ActiveRecord::Migration
  def change
    create_table :mentions do |t|
      t.references :user, null: false, index: true
      t.references :opinion, null: false, index: true
      t.timestamps null: false
    end
  end
end
