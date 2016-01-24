class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true
  belongs_to :user

  mount_uploader :source, AttachmentUploader

  def image?
    !(content_type =~ /^image\/.*/).nil?
  end

  def discussion
    return self.attachable if attachable_type == Discussion.to_s
    return attachable.try(:discussion)
  end
end
