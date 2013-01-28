FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :community_name do |n|
    "community_#{n}"
  end

  factory :user do
    email {generate :email}
    global_role 'normal'
    name 'Martijn'
    locale 'nl'
    password '123456'
    password_confirmation '123456'
    confirmed_at Time.now
    receive_assign_mail true
    receive_reminder_mail true
  end

  factory :task do
    name 'Do something'
    description 'Do something'
    deadline 1
    deadline_unit 'weeks'
    user_order '1,2,3'
    interval 3
    interval_unit 'weeks'
    repeat_infinite true
    user_id 1
    community_id 1
    repeat 1
    allocation_mode 'in_turns'
    allocated_user_id 1
    next_occurrence Date.today
    factory :task_single_allocation do
      allocation_mode 'user'
      association :allocated_user, factory: :user
    end
    should_be_checked false
    association :community, factory: :community

    factory :task_with_occurrences do
      ignore do
        occurrences_count 1
      end
      ignore do
        occurrences_user FactoryGirl.create(:user)
      end

      after(:create) do |task, evaluator|
        FactoryGirl.create_list(:task_occurrence, evaluator.occurrences_count, task: task, user: evaluator.occurrences_user)
      end
    end
  end

  factory :community do
    name {generate :community_name}
    creator_id 1
    factory :community_with_users do
      ignore do
        users_count 5
        members []
      end
      after(:create) do |community, evaluator|
        if evaluator.members.any?
          evaluator.members.each {|user| FactoryGirl.create(:community_user, community: community, user: user, role: 'admin')}
        else
          FactoryGirl.create_list(:community_user, evaluator.users_count, community: community, role: 'admin')
        end
      end
    end

  end

  factory :community_user do
    role 'normal'
    association :user, factory: :user
    association :community, factory: :community
  end

  factory :task_occurrence do
    task_name "Blabla"
    checked false
    deadline 2.week.since.to_date
    should_be_checked false
    remarks ""
    association :user, factory: :user
    association :task, factory: :task
    association :community, factory: :community
    time_in_minutes 60
    created_at Time.now
    updated_at Time.now
    factory :task_occurrence_should_be_checked do
      association :task, factory: :task, should_be_checked: true
      should_be_checked true
    end
  end

  factory :task_occurrence_passed_deadline, parent: :task_occurrence do
    deadline 2.weeks.ago.to_date
  end

  factory :invitation do
    status 'requested'
    association :community, factory: :community_with_users
    association :invitor, factory: :user
    invitee_email {generate :email}
    token "f2215de2764c983ae839f638c353ac"
    factory :invitation_with_invitee do
      mail = 'person7843758748574875@example.com'
      association :invitee, factory: :user, email: mail
      invitee_email mail
    end
  end

  factory :comment do
    title 'Test'
    body 'Blablablab'
    subject 'Test'
    association :user, factory: :user

    factory :comment_with_task_occurrence do
      association :commentable, factory: :task_occurrence
    end
  end 
end