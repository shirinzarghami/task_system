require 'test_helper'

class TaskOccurrenceTest < ActiveSupport::TestCase

  def setup
    ActionMailer::Base.deliveries.clear
  end

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
  
    ordered_user_ids = community.members.map(&:id).join(',')
    task = FactoryGirl.create(:task_with_occurrences, 
      allocation_mode: 'in_turns', 
      ordered_user_ids: ordered_user_ids,
      community: community,
      occurrences_user: community.members.second
    )
    
    task_occurrence = task.task_occurrences.first
    task_occurrence.allocate
    task_occurrence.save
    assert task_occurrence.user == community.members.third
  end

  test "allocate in turns with ignored user" do
    community = FactoryGirl.create(:community_with_users) # 5 users
  
    ordered_user_ids = community.members.first(4).map(&:id).join(',')
    ignored_user_ids = community.members.last.id.to_s # User number 5 is ignored
    task = FactoryGirl.create(:task_with_occurrences, 
      allocation_mode: 'in_turns', 
      ordered_user_ids: ordered_user_ids,
      ignored_user_ids: ignored_user_ids,
      community: community,
      occurrences_user: community.members.fourth
    )
    
    task_occurrence = task.task_occurrences.first
    task_occurrence.allocate
    task_occurrence.save
    assert task_occurrence.user == community.members.first #User 5 should not be scheduled, it should go back to one
  end

  test "allocate turns without a previous task occurrence" do
    community = FactoryGirl.create(:community_with_users)
    
    ordered_user_ids = community.members.map(&:id).join(',')
    task = FactoryGirl.create(:task, 
      allocation_mode: 'in_turns', 
      ordered_user_ids: ordered_user_ids,
      community: community
    )

    task_occurrence = FactoryGirl.build(:task_occurrence, task: task)
    task_occurrence.allocate

    assert task_occurrence.user == community.members.first
  end

  test "allocate turns with an invalid ordered_user_ids string" do
    community = FactoryGirl.create(:community_with_users)
    
    ordered_user_ids = '2,9389,34,344,434,324,455,A,f,ed,e'
    task = FactoryGirl.create(:task, 
      allocation_mode: 'in_turns', 
      ordered_user_ids: ordered_user_ids,
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
    assert task.next_allocated_user == user1, "The occurrence should be scheduled to user1, since it has 0 time"
    Task.schedule_upcoming_occurrences && task.reload
    assert task.task_occurrences.last.user == user1, "The occurrence should be scheduled to user1, since it has 0 time"

    2.times {FactoryGirl.create(:task_occurrence, task: task, user: user1)}
    assert task.next_allocated_user == user2, "The occurrence should be scheduled to user2, since it has less time"
  end

  test "allocate by time on all tasks within community" do
    community = FactoryGirl.create(:community_with_users, users_count: 2)
    user1, user2 = community.members.first(2)
      
    task1 = FactoryGirl.create(:task_with_occurrences, 
      allocation_mode: 'time',
      community: community,
      occurrences_user: user2,
      occurrences_count: 3
    )    

    task2 = FactoryGirl.create(:task_with_occurrences, 
      allocation_mode: 'time_all',
      community: community,
      occurrences_user: user1,
      occurrences_count: 2
    )

    assert task2.next_allocated_user == user1, "Should be scheduled to user1, since it has lowest total time"

    2.times {FactoryGirl.create(:task_occurrence, task: task1, user: user1)}
    assert task2.next_allocated_user == user2, "Should be scheduled to user2, since it has lowest total time"
  end


  test "send a reminder mail" do
    @user = FactoryGirl.create(:user)
    @task_occurrences = 2.times.map {FactoryGirl.create(:task_occurrence, deadline: 2.days.since, user: @user)}
    TaskOccurrence.send_reminders

    assert ActionMailer::Base.deliveries.size == 0, "Do not send mail more 24h before the deadline"

    TaskOccurrence.update_all deadline: 1.day.since
    TaskOccurrence.send_reminders
    mails = ActionMailer::Base.deliveries
    assert mails.size == 1, "Send 1 mail for 2 occurrences 24h or less before deadline"
    assert mails.last.to.first == @user.email, "Reminder to correct email"
    assert @task_occurrences.select {|to| to.reload.reminder_mail_sent == false}.size == 0

    TaskOccurrence.send_reminders
    mails = ActionMailer::Base.deliveries
    assert mails.size == 1, "Do not send mail again"

  end

  test "reminder mail completed task" do
    @user = FactoryGirl.create(:user)
    @task_occurrence = FactoryGirl.create(:task_occurrence, deadline: 1.days.since, user: @user, should_be_checked: true, checked: true)

    TaskOccurrence.send_reminders
    mails = ActionMailer::Base.deliveries
    assert mails.size == 0, "Do not send reminder when task is already completed"

  end


end
