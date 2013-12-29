namespace :necura  do
  task :schedule_upcoming_occurrences => :environment do
    Task.schedule_upcoming_occurrences
  end
  
  task :send_reminders => :environment do
    TaskOccurrence.send_reminders
  end

  task :schedule_repeatable_items => :environment do
    RepeatableItem.schedule_upcoming
  end
end