module CommentsHelper

  def comment_path(object, comment=nil)
    # if object.is_a? TaskOccurrence
    #   community_task_occurrence_comments_path(@community, object)
    #   community_task_occurrence_comment_path
    # elsif object.is_a? Payment
    #   community_payment_comments_path(@community, object)

    # end
    new_comment = comment || Comment
    url_for([@community, object, new_comment].compact)
  end
end
