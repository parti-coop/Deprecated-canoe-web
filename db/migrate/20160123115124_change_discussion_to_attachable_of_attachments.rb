class ChangeDiscussionToAttachableOfAttachments < ActiveRecord::Migration
  def up
    add_reference :attachments, :attachable, polymorphic: true, index: true

    query = "UPDATE attachments SET attachable_id = discussion_id"
    ActiveRecord::Base.connection.execute query
    say query

    query = "UPDATE attachments SET attachable_type = 'Discussion'"
    ActiveRecord::Base.connection.execute query
    say query

    change_column_null :attachments, :attachable_id, false
    change_column_null :attachments, :attachable_type, false
    remove_reference :attachments, :discussion
  end

  def down
    add_reference :attachments, :discussion, index: true

    query = "UPDATE attachments SET discussion_id = attachable_id"
    ActiveRecord::Base.connection.execute query
    say query

    remove_column :attachments, :attachable_id
    remove_column :attachments, :attachable_type
    change_column_null :attachments, :discussion_id, false
  end
end
