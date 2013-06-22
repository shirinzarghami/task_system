module CommentsHelper

  def comment_path(object, comment=nil)
    new_comment = comment || Comment
    url_for([@community, object, new_comment].compact)
  end
end
