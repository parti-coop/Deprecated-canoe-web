require 'test_helper'

class AttachmentsTest < ActionDispatch::IntegrationTest
  test 'create and destroy' do
    sign_in(users(:one))
    post attachments_path, { attachment: { source: fixture_file('files/test.png'), attachable_id: discussions(:discussion1).id, attachable_type: Discussion.to_s } }
    assert_equal fixture_file('files/test.png').tempfile.read, assigns(:attachment).source.file.read

    delete attachment_path(id: assigns(:attachment).id)
    refute Attachment.exists? assigns(:attachment).id
  end
end
