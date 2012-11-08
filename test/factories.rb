FactoryGirl.define do
  factory :user do
    email 'martijn@test.com'
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
    last_occurrence Time.now
    user_id 1
    community_id 1
    repeat 1
    start_on Date.today
    allocation_mode 'in_turns'
    allocated_user_id 1
    # association :community, factory: :community
  end

  factory :community do
    name 'Test'
    subdomain 'test'
  end

  factory :task_occurrence do
    checked false
    deadline 2.week.since
    remarks ""
    association :user, factory: :user
    completed_a
    created_at Time.now
    updated_at Time.now

  end
end