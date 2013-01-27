class CommentMailer < ActionMailer::Base
  default from: "administrator@tasksystem.com"

  def posted user, comment
    @user = user
    @comment = comment
    @link = find_comment_link(@comment)
    mail to: @user.email do |format|
      format.html { render :layout => 'email' }
      # format.text
    end
  end

  def find_comment_link comment
    if comment.commentable.class == TaskOccurrence
      @community = comment.commentable.task.community
      community_task_occurrence_url(@community, @comment.commentable)
    end
  end
end
