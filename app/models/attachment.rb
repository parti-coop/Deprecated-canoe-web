class Attachment < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :attachable, -> { unscope(where: :deleted_at) }, polymorphic: true

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
