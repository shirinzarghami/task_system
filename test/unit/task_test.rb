require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test "instantiate in words" do
    ['days', 'months', 'weeks'].each do |unit|
      task = FactoryGirl.build(:task, interval_unit: unit, interval: 3)
      assert_equal task.instantiate_in_words, "Every 3 #{unit}"
    end
  end

  test "allocation mode string" do
    Task::ALLOCATION_MODES.each do |mode|
      task = FactoryGirl.build(:task, allocation_mode: mode.to_s)
      assert task.save
    end

    task = FactoryGirl.build(:task, allocation_mode: 'onzin')
    assert !task.save
  end

  test "schedule upcoming daily tasks" do
    (1..5).to_a.each do |number|
      task = FactoryGirl.create(:task, interval_unit: 'days', interval: 3, last_occurrence: number.days.ago)
      # Task.schedule_upcoming_occurrences
      # assert task.task_occurrences.count == (number < 3 ? 0 : 1)
    end
      debugger
  end

end
