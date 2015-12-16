ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class CarrierWave::Mount::Mounter
  def store!
    # Not storing uploads in the tests
  end
end

CarrierWave.root = 'test/fixtures/files'

class ActiveSupport::TestCase
  include ActionDispatch::TestProcess #allows fixture_file_upload method
  
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  # CarrierWave image file fixtures
  CarrierWave.root = Rails.root.join('test/fixtures/files')
  
  # Clean up CarrierWave tmp files after tests
  def after_teardown
    super
    CarrierWave.clean_cached_files!(0)
  end

  # Add more helper methods to be used by all tests here...
  def is_logged_in?
    !session[:user_id].nil?
  end
  
  # Logs in a test user
  def log_in_as(user, options = {})
    password      = options[:password]    || 'password'
    remember_me   = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: { email:        user.email,
                                  password:     password,
                                  remember_me:  remember_me }
    else
      session[:user_id] = user.id
    end
  end
    
  # Logs out a test user  
  def log_out(user)
    if integration_test?
      delete logout_path, session: { user_id: user.id }
    else
      session.delete[user.id]
    end
  end

  private
    
    # Returns true inside an integration test
    def integration_test?
      defined?(post_via_redirect)
    end
end