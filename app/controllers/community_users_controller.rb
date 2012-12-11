class CommunityUsersController < ApplicationController
  before_filter :find_community_user
  before_filter :check_community_admin, only: [:update]
  before_filter :check_destroy_allowed, only: [:destroy]

  def destroy
    if @community_user.destroy
      flash[:notice] = t('community_users.destroy.unsubscribed')
      redirect_to communities_path
    else
      flash[:error] = t('messages.error')
      redirect_to communities_path
    end
  end

  def update
    if @community_user.update_attributes community_user_params
      flash[:notice] = t('messages.save_success')
      redirect_to community_path(@community_user.community)
    else
      flash[:error] = t('messages.error')
      redirect_to community_path(@community_user.community)
    end
  end

  private
    def find_community_user
      @community_user = CommunityUser.find(params[:id])
    end

    def check_community_admin
      check community_admin?(@community_user.community)
    end

    def check_destroy_allowed
      result = (@community_user.user == @user or community_admin?(@community_user.community))
      check result
    end

    def community_user_params
      params.require(:community_user).permit(:role)
    end
end
