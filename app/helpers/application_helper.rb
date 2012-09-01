module ApplicationHelper

  def community_admin?
    @community_user.role == 'admin'
  end


end
