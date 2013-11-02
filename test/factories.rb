FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@exaample.com"
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
    receive_comment_mail true
  end

  factory :start_saldo_distribution do

  end

  factory :task do
    name 'Do something'
    description 'Do something'
    deadline 1
    deadline_unit 'weeks'
    ordered_user_ids '1,2,3'
    interval 3
    interval_unit 'weeks'
    repeat_infinite true
    user_id 1
    community_id 1
    repeat 1
    time Time.new(0) + 1.hour + 30.minutes
    allocation_mode 'in_turns'
    allocated_user_id 1
    next_occurrence Date.today
    instantiate_automatically true
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
    association :start_saldo_distribution, factory: :start_saldo_distribution
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

  factory :community_user_with_community, class: CommunityUser do
    role 'normal'
    association :user, factory: :user
    association :community, factory: :community_with_users
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

  factory :user_saldo_modification do
    price 25
    percentage 25
    checked true
  end

  factory :product_declaration do
    title 'Test'
    description 'Test'
    date '2013-06-23'
    type 'ProductDeclaration'
    price 100
    association :community_user, factory: :community_user_with_community


    factory :product_declaration_with_saldos do
      ignore do
        community_users_set_1 []
        saldo_price_1 0
        community_users_set_2 []
        saldo_price_2 0
      end
      after(:create) do |payment, evaluator|
        if evaluator.community_users_set_1.any?
          evaluator.community_users_set_1.each do |cu|
            FactoryGirl.create :user_saldo_modification, community_user: cu, price: evaluator.saldo_price_1, chargeable: payment
          end
        end       
        if evaluator.community_users_set_2.any?
          evaluator.community_users_set_2.each do |cu|
            FactoryGirl.create :user_saldo_modification, community_user: cu, price: evaluator.saldo_price_2, chargeable: payment
          end
        end
      end
    end
  end

  FactoryGirl.define do

    factory :repeatable_item_every_week, :class => RepeatableItem do
      repeat_every_unit 'weeks'
      repeat_number 1
      repeat_infinite false
      next_occurrence Time.now
      repeat_every_number 1
      deadline_unit 'weeks'
      deadline_number 1
      has_deadline true
      enabled true       
    end
  end

end