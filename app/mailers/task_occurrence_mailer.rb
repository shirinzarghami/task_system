class TaskOccurrenceMailer < ActionMailer::Base
  default from: "administrator@tasksystem.com"

  def assign user
    @user = user
    mail to: user.email
  end

  def reminder
    @user = user
    mail to: user.email
  end
end
