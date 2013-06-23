module CommentsHelper

  def comment_path(object, comment=nil)
    new_comment = comment || Comment
    url_for([@community, object, new_comment].compact)
  end

  def view_comment_url(comment)
    polymorphic_url([@community, comment.commentable].compact)
  end
end
