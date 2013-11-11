
class CommunitiesController < ApplicationController
  include ActiveModel::ForbiddenAttributesProtection

  add_crumb(lambda {|instance| instance.t('breadcrumbs.communities')}) { |instance| instance.send :communities_path }
  before_filter :find_community, only: [:show]
  before_filter :new_invitations_flash

  def index
    @community_users = @user.community_users.paginate(page: params[:page], per_page: 10)
    @invitations = current_user.invitations.paginate(page: params[:invitation_page], per_page: 10)
  end

  def create
    @new_community = Community.new community_params
    @new_community_user = @new_community.community_users.build role: 'admin', user: @user
    
    @start_saldos = @new_community.build_start_saldo_distribution
    @start_saldos.user_saldo_modifications.build community_user: @new_community_user, price: 0, percentage: 0
    
    if @new_community.save
      flash[:notice] = t('communities.new.created')
      redirect_to communities_path
    else
      flash[:error] = t('communities.new.not_created')
      render action: 'new'
    end
  end

  def show
    set_community_breadcrumb
    @invitations = @community.invitations.paginate(page: params[:invitation_page], per_page: 10)
    @community_users = @community.community_users.paginate(page: params[:page], per_page: 20)
  end

  def new
    @new_community = Community.new
  end

  private
    def new_invitations_flash
      flash[:info] = t('messages.new_invitation') if current_user.invitations.requested.any?
    end

    def community_params
      {creator: current_user}.merge params.require(:community).permit(:name, :subdomain, :invitation_emails)
    end



end
