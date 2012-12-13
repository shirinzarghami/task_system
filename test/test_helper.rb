ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # This is required as the to_schedule scope in task does not work in a test environment.
  # Timecop does not change the MySQL time
  def schedule_task_occurrences
    Task.all.select {|t| t.next_occurrence <= Date.today}.each {|t| t.schedule}
  end

end

class ActionController::TestCase
  include Devise::TestHelpers
end
