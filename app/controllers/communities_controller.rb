
class CommunitiesController < ApplicationController
  before_filter :new_invitations_flash
  def index
    @community_users = @user.community_users.paginate(page: params[:page], per_page: 10)
    @invitations = current_user.invitations.paginate(page: params[:invitation_page], per_page: 10)
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
    @invitations = @community.invitations.paginate(page: params[:invitation_page], per_page: 10)
    @community_users = @community.community_users.paginate(page: params[:page], per_page: 20)
  end


  def new
    @community = Community.new
  end

  protected
    def new_invitations_flash
      flash[:info] = t('messages.new_invitation') if current_user.invitations.any?
    end


end
