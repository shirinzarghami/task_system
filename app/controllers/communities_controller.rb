
class CommunitiesController < ApplicationController
  before_filter :new_invitations_flash
  def index
    @community_users = @user.community_users
    @invitations = current_user.invitations
  end

  def create
    @community = Community.new params[:community]
    @community.community_users.build role: 'admin', user: @user
    @community.invite @user
    if @community.save
      flash[:notice] = t('communities.new.created')
      redirect_to communities_path
    else
      flash[:error] = t('communities.new.not_created')
      render action: 'new'
    end
  end

  def show
    @invitations = @community.invitations
  end


  def new
    @community = Community.new
  end

  protected
    def new_invitations_flash
      flash[:info] = t('messages.new_invitation') if current_user.invitations.any?
    end


end
