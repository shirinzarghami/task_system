class CommunitiesController < ApplicationController
  def index
    @community_users = @user.community_users
  end

  def create
    @community = Community.new params[:community]
    @community.deduce_subdomain
    @community.community_users.build role: 'admin', user: @user
    @community.invite @user

    if @community.save
      # create_invitations
      flash[:notice] = t('communities.new.created')
      redirect_to communities_path
    else
      flash[:warning] = t('communities.new.not_created')
      render action: 'new'
    end
  end

  def edit
  end

  def destroy
  end

  def new
    @community = Community.new
  end

  def update
  end


end
