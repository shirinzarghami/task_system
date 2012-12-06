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

  test "schedule task occurrences" do
    Timecop.freeze(2.weeks.ago)
    task = FactoryGirl.create(:task_single_allocation, interval: 2, interval_unit: 'weeks', next_occurrence: Date.today)
    assert task.task_occurrences.count == 0, 'before scheduling there should be no occurrences'
    Task.schedule_upcoming_occurrences
    assert task.task_occurrences.count == 1, 'after scheduling, one task occurrence should exist'

    assert task.reload.next_occurrence == 2.weeks.since.to_date, 'next occurrence should be one interval later (2 weeks)'
    Timecop.freeze(1.week.since)
    schedule_task_occurrences
    assert task.task_occurrences.count == 1, 'when scheduling before the interval has passed, no occurrence should be created'

    Timecop.freeze(1.week.since)
    schedule_task_occurrences
    assert task.task_occurrences.count == 2, 'when scheduling after the interval has passed, an occurrence should be created'
  end


  test "set the correct deadline" do
    task = FactoryGirl.create :task_single_allocation, deadline_unit: 'months', deadline: 3
    Task.schedule_upcoming_occurrences
    assert task.task_occurrences.count == 1, 'one occurrence should be created after scheduling'
    assert task.task_occurrences.last.deadline.to_date == Date.today + 3.months, 'the deadline should be set depending on the task deadline interval'
  end

  test "task repetition" do
    task = FactoryGirl.create :task_single_allocation, repeat_infinite: false, repeat: 1
    Task.schedule_upcoming_occurrences
    task.reload
    assert task.repeat == 0, 'repeat value should be decreased by one'
    assert task.task_occurrences.count == 1, 'one occurrence should be scheduled'
    
    task.update_attributes next_occurrence: Date.today
    Task.schedule_upcoming_occurrences
    task.reload
    assert task.repeat == 0, 'repeat value should not go below 0'
    assert task.task_occurrences.count == 1, 'when repeat 0, a new occurrence should not be scheduled'
  end

  # test "last occurrence should change when a new start time is selected" do
  #   task = FactoryGirl.create(:task, last_occurrence: 4.weeks.ago)
  #   task.update_attributes start_on: 1.week.since
  #   assert task.last_occurrence = 1.week.since
  # end

end
