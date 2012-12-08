class CommunityUsersController < ApplicationController
  before_filter :find_community_user
  before_filter :check_community_admin, only: [:update]
  before_filter :check_destroy_allowed, only: [:destroy]

  def destroy
    if @community_user.destroy
      flash[:notice] = t('communitie_users.destroy.unsubscribed')
      redirect_to communities_path
    else
      flash[:error] = t('messages.error')
      redirect_to communities_path
    end
  end

  def update
    if @community_user.update_attributes params[:community_user].except(:user_id, :community_id)
      flash[:notice] = t('messages.save_success')
      redirect_to community_path(@community_user.community)
    else
      flash[:error] = t('messages.error')
      redirect_to community_path(@community_user.community)
    end
  end

  protected

    def find_community_user
      @community_user = CommunityUser.find(params[:id])
    end

    def user_is_community_admin?
      CommunityUser.find_by_community_id_and_user_id!(@community_user.community, @user).role == 'admin'
    end

    def check_community_admin
      check user_is_community_admin?
    end

    def check_destroy_allowed
      check @community_user.user == @user or user_is_community_admin?
    end
end
