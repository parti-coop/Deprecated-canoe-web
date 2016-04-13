class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.references :user, null: false, index: true
      t.string :device_id
      t.string :device_platform
    end
  end
end
