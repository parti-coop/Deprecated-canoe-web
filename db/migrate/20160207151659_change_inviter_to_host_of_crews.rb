class ChangeInviterToHostOfCrews < ActiveRecord::Migration
  def change
    rename_column :crews, :inviter_id, :host_id
  end
end
