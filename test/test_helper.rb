ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'factory_girl_rails'
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  Debugger.settings[:autoeval] = true
  # This is required as the to_schedule scope in task does not work in a test environment.
  # Timecop does not change the MySQL time
  def schedule_task_occurrences
    Task.all.select {|t| t.next_occurrence <= Date.today}.each {|t| t.schedule}
  end

end

class ActionController::TestCase
  include Devise::TestHelpers

  def assert_notice_flash
    assert flash[:error].nil? and flash[:notice].present?
  end

  def assert_error_flash
    assert flash[:error].present? and flash[:notice].nil?
  end
end

# Transactional fixtures do not work with Selenium tests, because Capybara
# uses a separate server thread, which the transactions would be hidden
# from. We hence use DatabaseCleaner to truncate our test database.
DatabaseCleaner.strategy = :truncation

class ActionDispatch::IntegrationTest
  require 'integration/common_capybara'
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  # Stop ActiveRecord from wrapping tests in transactions
  self.use_transactional_fixtures = false

  teardown do
    DatabaseCleaner.clean       # Truncate the database
    Capybara.reset_sessions!    # Forget the (simulated) browser state
    Capybara.use_default_driver # Revert Capybara.current_driver to Capybara.default_driver
  end
end