class TaskOccurrenceMailer < ActionMailer::Base
  # layout 'email'
  default from: "administrator@tasksystem.com"
  def assign user
    @user = user
    mail to: user.email do |format|
      format.html { render :layout => 'email' }
    end
  end

  def reminder
    @user = user
    mail to: user.email
  end
end
