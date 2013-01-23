namespace :necura  do
  task :schedule_upcoming_occurrences => :environment do
    Task.schedule_upcoming_occurrences
  end
  
  task :send_reminders => :environment do
    TaskOccurrence.send_reminders
  end
end