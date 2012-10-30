require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test "instantiate in words" do
    ['days', 'months', 'weeks'].each do |unit|
      task = FactoryGirl.build(:task, interval_unit: unit, interval: 3)
      assert_equal task.instantiate_in_words, "Every 3 #{unit}"
    end
  end
end
