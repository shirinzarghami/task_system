require 'test_helper'

class TaskOccurrenceTest < ActiveSupport::TestCase

  test "completed method for a task that should be checked" do
    Timecop.freeze(Time.now) do
      task_occurrence = FactoryGirl.create(:task_occurrence_should_be_checked)
      assert !task_occurrence.completed?
      
      task_occurrence.update_attributes checked: true
      assert task_occurrence.completed?
    end
  end

  test "completed method for a task that should not be checked" do
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
    task = FactoryGirl.create(:task_with_occurrences, 
      allocation_mode: 'in_turns', 
      user_order: user_order,
      community: community,
      occurrences_user: community.members.second
    )
    
    task_occurrence = task.task_occurrences.first
    task_occurrence.allocate
    task_occurrence.save
    assert task_occurrence.user == community.members.third
  end

  test "allocate turns without a previous task occurrence" do
    community = FactoryGirl.create(:community_with_users)
    
    user_order = community.members.map(&:id).join(',')
    task = FactoryGirl.create(:task, 
      allocation_mode: 'in_turns', 
      user_order: user_order,
      community: community
    )

    task_occurrence = FactoryGirl.build(:task_occurrence, task: task)
    task_occurrence.allocate

    assert task_occurrence.user == community.members.first
  end

  test "allocate turns with an invalid user_order string" do
    community = FactoryGirl.create(:community_with_users)
    
    user_order = '2,9389,34,344,434,324,455,A,f,ed,e'
    task = FactoryGirl.create(:task, 
      allocation_mode: 'in_turns', 
      user_order: user_order,
      community: community,
      user: community.members.first
    )

    task_occurrence = FactoryGirl.build(:task_occurrence, task: task)
    task_occurrence.allocate
    assert task_occurrence.user == task.user, "When the order string is invalid, it should be allocated to the creator of the task"
  end

  test "todo scope: should be checked" do
    task_occurrence = FactoryGirl.create(:task_occurrence_should_be_checked)
    assert TaskOccurrence.todo.include?(task_occurrence)

    task_occurrence.update_attributes checked: true
    assert !TaskOccurrence.todo.include?(task_occurrence)
  end

  test "todo scope: should not be checked" do
    task_occurrence = FactoryGirl.create(:task_occurrence)
    assert TaskOccurrence.todo.include?(task_occurrence)

    task_occurrence.update_attributes deadline: 2.weeks.ago
    assert !TaskOccurrence.todo.include?(task_occurrence)
  end

  test "allocate by time" do
    community = FactoryGirl.create(:community_with_users, users_count: 2)
    user1, user2 = community.members.first(2)
      
    task = FactoryGirl.create(:task_with_occurrences, 
      allocation_mode: 'time',
      community: community,
      occurrences_user: user2,
      occurrences_count: 2
    )
    debugger
    assert task.next_allocated_user == user1, "The occurrence should be scheduled to member2, since it has 0 time"
    Task.schedule_upcoming_occurrences && task.reload
    assert task.task_occurrences.last.user == user1, "The occurrence should be scheduled to member2, since it has 0 time"
  end

end
