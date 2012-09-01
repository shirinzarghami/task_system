class CommunityUsersController < ApplicationController
  skip_before_filter :find_community

  def destroy
    @community_user = CommunityUser.find(params[:id])
    if @community_user and destroy_allowed? and @community_user.destroy
      flash[:notice] = t('communities.destroy.unsubscribed')
      redirect_to communities_path
    else
      flash[:error] = t('messages.error')
      redirect_to communities_path
    end
  end

  def create
  end

  def update
  end

  protected
    def destroy_allowed?
      @community_user.user == @user or user_is_admin?
    end

    def user_is_admin?
      current_community_user = @community_user.community.community_users.find_by_user(@user)
      current_community_user.present? and current_community_user.role == 'admin'
    end


end
