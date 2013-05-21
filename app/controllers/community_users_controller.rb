class CommunityUsersController < ApplicationController
  add_crumb(lambda {|instance| instance.t('breadcrumbs.communities')}) { |instance| instance.send :communities_path }
  before_filter :find_community, only: :show
  before_filter :find_community_user
  before_filter :check_community_admin, only: [:update]
  before_filter :check_destroy_allowed, only: [:destroy]

  def destroy
    if @community_user.destroy
      flash[:notice] = t('community_users.destroy.unsubscribed')
      redirect_to communities_path
    else
      flash[:error] = error_messages_for @community_user, t('messages.error')
      redirect_to communities_path
    end
  end

  def update
    if @community_user.update_attributes community_user_params
      flash[:notice] = t('messages.save_success')
      respond_to do |format|
        format.html {redirect_to community_path(@community_user.community)}
        format.js {render 'shared/ajax_flash'}
      end
    else
      flash[:error] = error_messages_for @community_user, t('messages.error') 
      respond_to do |format|
        format.html {redirect_to community_path(@community_user.community)}
        format.js {render 'shared/ajax_flash'}
      end
    end
  end

  def show
    add_crumb(@community_user.user.name, community_community_user_path(@community, @community_user))
    @show_user = @community_user.user
  end

  private
    def find_community_user
      @community_user = if @community
                          @community.community_users.find params[:id]
                        else
                           CommunityUser.find(params[:id])
                        end
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
