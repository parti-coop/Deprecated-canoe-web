class AddUniqueConstraintsToDevices < ActiveRecord::Migration
  def change
    add_index :devices, [:user_id, :device_id, :device_platform], unique: true
  end
end
