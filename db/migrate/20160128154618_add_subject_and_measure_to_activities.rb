class AddSubjectAndMeasureToActivities < ActiveRecord::Migration
  def execute_sql sql
    ActiveRecord::Base.connection.execute sql
    say sql
  end
  def up
    if Rails.env.test? or Rails.env.development?
      execute_sql 'CREATE TABLE activities_backup AS SELECT * FROM activities'
    else
      execute_sql 'CREATE TABLE activities_backup LIKE activities'
      execute_sql 'INSERT INTO activities_backup SELECT * FROM activities'
    end
    add_reference :activities, :subject, index: true, polymorphic: true
    add_reference :activities, :measure, index: true, polymorphic: true
    add_column :activities, :task, :string

    PublicActivity::Activity.record_timestamps = false
    PublicActivity::Activity.all.each do |activity|
      if activity.recipient_with_deleted.nil?
        activity.destroy
        next
      end
      case activity.key
      when 'discussions.update_decision'
        activity.update_attributes(key: 'discussion.decision',
          task: 'update',
          subject: activity.recipient_with_deleted,
          measure: nil)
      when 'opinions.create'
        activity.update_attributes(key: 'opinion',
          task: 'create',
          subject: activity.recipient_with_deleted,
          measure: nil)
      when 'votes.in_favor'
        puts activity.inspect
        activity.update_attributes(key: 'proposal',
          task: 'vote.in_favor',
          subject: activity.recipient_with_deleted.proposal_with_deleted,
          measure: activity.recipient_with_deleted)
      when 'votes.opposed'
        activity.update_attributes(key: 'proposal',
          task: 'vote.opposed',
          subject: activity.recipient_with_deleted.proposal_with_deleted,
          measure: activity.recipient_with_deleted)
      when 'votes.unvote'
        activity.update_attributes(key: 'proposal',
          task: 'vote.unvote',
          subject: activity.recipient_with_deleted.proposal_with_deleted,
          measure: activity.recipient_with_deleted)
      when 'proposals.create'
        activity.update_attributes(key: 'proposal',
          task: 'create',
          subject: activity.recipient_with_deleted,
          measure: nil)
      when 'proposals.update'
        activity.update_attributes(key: 'proposal',
          task: 'update',
          subject: activity.recipient_with_deleted,
          measure: nil)
      when 'proposals.destroy'
        activity.update_attributes(key: 'proposal',
          task: 'destroy',
          subject: activity.recipient_with_deleted,
          measure: nil)
      when 'discussions.attachments.create'
        activity.update_attributes(key: 'discussion.decision',
          task: 'attachment.create',
          subject: activity.recipient_with_deleted.attachable,
          measure: activity.recipient_with_deleted)
      when 'discussions.attachments.destroy'
        activity.update_attributes(key: 'discussion.decision',
          task: 'attachment.destroy',
          subject: activity.recipient_with_deleted.attachable,
          measure: activity.recipient_with_deleted)
      when 'proposals.attachments.create'
        activity.update_attributes(key: 'proposal',
          task: 'attachment.create',
          subject: activity.recipient_with_deleted.attachable,
          measure: activity.recipient_with_deleted)
      when 'proposals.attachments.destroy'
        activity.update_attributes(key: 'proposal',
          task: 'attachment.destroy',
          subject: activity.recipient_with_deleted.attachable,
          measure: activity.recipient_with_deleted)
      else
        raise "Unknow: #{activity.inspect}"
      end
    end

    change_column_null :activities, :subject_id, false
    change_column_null :activities, :subject_type, false
  end

  def down
    raise "unimplemented"
  end
end
