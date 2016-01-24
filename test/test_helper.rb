ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'parti_sso_client/test_helpers'

module CanoeTestHelpers
  def fixture_file(flie_name)
    fixture_file_upload(flie_name, nil, true)
  end
end

class ActiveSupport::TestCase
  fixtures :all
  include CanoeTestHelpers
  include ActionDispatch::TestProcess
end

Minitest.after_run do
  if Rails.env.test?
    FileUtils.rm_rf(Dir["#{Rails.root}/test/uploads/[^.]*"])
    FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads/tmp/[^.]*"])
  end
end

class ActionDispatch::IntegrationTest
  include PartiSsoClient::TestHelpers
end


