ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

module CanoeTestHelpers
  def fixture_file(flie_name)
    fixture_file_upload(flie_name, nil, true)
  end
end

class ActiveSupport::TestCase
  fixtures :all
  include CanoeTestHelpers
  include ActionDispatch::TestProcess

  # Returns true if a test user is logged in.
  def signed_in?
    !session[:user_id].nil?
  end

  # Logs in a test user.
  def sign_in(user, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post_via_redirect user_session_path, user: { email:       user.email,
                                                   password:    password,
                                                   remember_me: remember_me,
                                                   provider:    'email' }
    else
      raise "unimplemented"
    end
  end

  # Logs in a test user.
  def sign_out
    if integration_test?
      delete_via_redirect destroy_user_session_path
    else
      raise "unimplemented"
    end
  end

  private

  # Returns true inside an integration test.
  def integration_test?
    defined?(post_via_redirect)
  end
end

Minitest.after_run do
  if Rails.env.test?
    FileUtils.rm_rf(Dir["#{Rails.root}/test/uploads/[^.]*"])
    FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads/tmp/[^.]*"])
  end
end

class ActionController::TestCase
  include Devise::TestHelpers
end


