class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :file, null: false
      t.string :content_type
      t.string :original_filename, null: false
      t.references :user, null: false, index: true
      t.references :discussion, null: false, index: true
      t.timestamps null: false
    end
  end
end
