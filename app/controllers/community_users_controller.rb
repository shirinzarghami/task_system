class CommunityUsersController < ApplicationController
  skip_before_filter :find_community
  before_filter :find_community_user, only: [:destroy, :update]
  before_filter :edit_allowed?, only: [:destroy, :update]
  
  def destroy
    if @community_user.destroy
      flash[:notice] = t('communitie_users.destroy.unsubscribed')
      redirect_to communities_path
    else
      flash[:error] = t('messages.error')
      redirect_to communities_path
    end
  end

  def create
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
      check @community_user.present?, communities_path, t('community_users.not_found')
    end

    def edit_allowed?
      unless @community_user.user == @user or user_is_community_admin?
        flash[:error] = t('messages.not_allowed')
        redirect_to communities_path
      end
    end

    def user_is_community_admin?
      current_community_user = @community_user.community.community_users.find_by_user_id(@user)
      current_community_user.present? and current_community_user.role == 'admin'
    end





end
