require 'test_helper'

class TaskOccurrenceTest < ActiveSupport::TestCase

  test "completed method which should be checked" do
    Timecop.freeze(Time.now) do
      task_occurrence = FactoryGirl.create(:task_occurrence_should_be_checked)
      assert !task_occurrence.completed?
      
      task_occurrence.update_attributes checked: true
      assert task_occurrence.completed?
    end
  end

  test "completed method which should not be checked" do
    Timecop.freeze(Time.now) do
      task_occurrence = FactoryGirl.create(:task_occurrence)
      assert !task_occurrence.completed? 

      task_occurrence = FactoryGirl.create(:task_occurrence_passed_deadline)
      assert task_occurrence.completed?
    end
  end

  test "allocate in turns" do
    community = FactoryGirl.create(:community_with_users)
  
    user_order = community.members.map(&:id).join(',')
    task = FactoryGirl.create(:task_with_occurrences, allocation_mode: 'in_turns', user_order: user_order, community: community, occurrences_user: community.members.second)
    
    # task_occurrence = FactoryGirl.create(:task_occurrence, task: task, user: user_list.second)

    task_occurrence = task.task_occurrences.first
    task_occurrence.allocate
    task_occurrence.save
    assert task_occurrence.user == community.members.third
  end
end
