class Attachment < ActiveRecord::Base
  belongs_to :discussion
  belongs_to :user

  mount_uploader :file, AttachmentUploader

  def image?
    !(content_type =~ /^image\/.*/).nil?
  end
end
