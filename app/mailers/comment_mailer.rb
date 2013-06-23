class CommentMailer < ActionMailer::Base
  include CommentsHelper
  helper :comments
  default from: "administrator@tasksystem.com"

  def posted community, user, comment
    @user = user
    @comment = comment
    @community = community

    mail to: @user.email do |format|
      format.html { render :layout => 'email' }
      # format.text
    end
  end

end
