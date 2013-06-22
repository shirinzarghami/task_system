module CommentsHelper

  def comment_submit_path(object)
    if object.is_a? TaskOccurrence
      community_task_occurrence_comments_path(@community, object)
    elsif object.is_a? Payment
      community_payment_comments_path(@community, object)

    end
  end
end
