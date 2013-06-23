namespace :necura  do
  # task :schedule_upcoming_occurrences => :environment do
  #   Task.schedule_upcoming_occurrences
  # end
  
  task :send_reminders => :environment do
    TaskOccurrence.send_reminders
  end

  task :send_comment_notifications => :environment do
    Comment.send_notifications
  end
end