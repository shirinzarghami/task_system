class CommentMailer < ActionMailer::Base
  include CommentsHelper
  extend MailerHelper
  default from: default_from
  helper :comments

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
