class TaskOccurrenceMailer < ActionMailer::Base
  extend MailerHelper
  default from: default_from
  
  def assign user, *task_occurrences 
    @user = user
    @task_occurrences = task_occurrences.empty? ? @user.task_occurrences.to_email : task_occurrences

    mail to: @user.email do |format|
      format.html { render :layout => 'email' }
      # format.text
    end
  end

  def reminder user, task_occurrences
    @task_occurrences = task_occurrences
    @user = user
    mail to: user.email do |format|
      format.html { render :layout => 'email' }
      # format.text
    end
  end
end
