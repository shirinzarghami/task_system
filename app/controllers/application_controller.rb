class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :find_user
  before_filter :find_community
  def find_user
    @user = current_user
  end

  def find_community
    @community = @user.communities.find_by_subdomain params.has_key?(:community_id) ? params[:community_id] : params[:id] if @user
    @community_user = CommunityUser.find_by_community_id_and_user_id(@community, @user)
  end



  def check_community
    unless @community_user and @community
      flash[:error] = t('messages.not_allowed')
      redirect_to communities_path
    end
  end

  def check_admin
    unless @community_user and @community_user.role == 'admin'
      flash[:error] = t('messages.not_allowed')
      redirect_to communities_path
    end
  end
end
