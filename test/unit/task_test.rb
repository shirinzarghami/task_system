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

  test "schedule first task event" do
    task = Timecop.freeze(2.weeks.ago) do
      task = FactoryGirl.create(:task_single_allocation, interval: 2, interval_unit: 'weeks')
      assert task.task_occurrences.count == 0
      task
    end
    Timecop.freeze(1.week.ago) do
      debugger
      Task.schedule_upcoming_occurrences
      assert task.task_occurrences.count == 0
    end
    Task.schedule_upcoming_occurrences
    assert task.task_occurrences.count == 1
  end

  test "schedule upcoming daily tasks" do
    (2..4).to_a.each do |number|
      task = FactoryGirl.create(:task_single_allocation, interval_unit: 'days', interval: 3, last_occurrence: number.days.ago)
      Task.schedule_upcoming_occurrences
      assert task.task_occurrences.count == (number < 3 ? 0 : 1)
    end
  end

  test "schedule upcoming weekly tasks" do
    (2..4).to_a.each do |number|
      task = FactoryGirl.create(:task_single_allocation, interval_unit: 'weeks', interval: 3, last_occurrence: number.weeks.ago)
      Task.schedule_upcoming_occurrences
      assert task.task_occurrences.count == (number < 3 ? 0 : 1)
    end
  end

  test "schedule upcoming monthly tasks" do
    (2..4).to_a.each do |number|
      task = FactoryGirl.create(:task_single_allocation, interval_unit: 'months', interval: 3, last_occurrence: number.months.ago)
      Task.schedule_upcoming_occurrences
      assert task.task_occurrences.count == (number < 3 ? 0 : 1)
    end
  end

  test "set the correct deadline" do
    Timecop.freeze(Time.now) do
      task = FactoryGirl.create(:task_single_allocation, deadline_unit: 'months', deadline: 3, last_occurrence: 4.weeks.ago)
      Task.schedule_upcoming_occurrences
      assert task.task_occurrences.count == 1
      # For some reason comparing time objects doesn't work
      assert task.task_occurrences.last.deadline.localtime.to_s == (Time.now + 3.months).to_s
    end
  end

  test "last occurrence should change when a new start time is selected" do
    task = FactoryGirl.create(:task, last_occurrence: 4.weeks.ago)
    task.update_attributes start_on: 1.week.since
    assert task.last_occurrence = 1.week.since
  end

end
