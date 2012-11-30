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
  end

  factory :task do
    name 'Do something'
    description 'Do something'
    deadline 100
    deadline_unit 'weeks'
    user_order '1,2,3'
    interval 3
    interval_unit 'weeks'
    # last_occurrence Time.now
    user_id 1
    community_id 1
    repeat 1
    start_on Date.today
    allocation_mode 'in_turns'
    allocated_user_id 1
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

    factory :community_with_users do
      ignore do
        users_count 5
      end
      after(:create) do |community, evaluator|
        FactoryGirl.create_list(:community_user, evaluator.users_count, community: community)
      end
    end

  end

  factory :community_user do
    role 'normal'
    association :user, factory: :user
    association :community, factory: :community
  end

  factory :task_occurrence do
    checked false
    deadline 2.week.since
    remarks ""
    association :user, factory: :user
    association :task, factory: :task
    created_at Time.now
    updated_at Time.now
    factory :task_occurrence_should_be_checked do
      association :task, factory: :task, should_be_checked: true
    end
  end

  factory :task_occurrence_passed_deadline, parent: :task_occurrence do
    deadline 2.weeks.ago
  end
end