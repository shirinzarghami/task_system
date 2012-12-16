class TaskOccurrenceMailer < ActionMailer::Base
  default from: "administrator@tasksystem.com"
  def assign user, *task_occurrences 
    @user = user
    @task_occurrences = task_occurrences.empty? ? @user.task_occurrences.to_email : task_occurrences

    mail to: @user.email do |format|
      format.html { render :layout => 'email' }
      format.text
    end
  end

  def reminder
    @user = user
    mail to: user.email do |format|
      format.html { render :layout => 'email' }
      format.text
    end
  end
end
