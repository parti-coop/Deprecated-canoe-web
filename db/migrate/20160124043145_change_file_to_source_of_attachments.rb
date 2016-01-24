class ChangeFileToSourceOfAttachments < ActiveRecord::Migration
  def change
    rename_column :attachments, :file, :source
  end
end
