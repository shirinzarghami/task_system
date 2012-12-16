class TaskOccurrenceMailer < ActionMailer::Base
  default from: "administrator@tasksystem.com"
  def assign user
    @user = user
    mail to: user.email do |format|
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
