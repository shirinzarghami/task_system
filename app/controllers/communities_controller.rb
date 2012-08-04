class CommunitiesController < ApplicationController
  def index
    @community_users = @user.community_users
  end

  def create
    @community_user = @user.community_users.build role: 'admin'
    @community = @community_user.build_community params[:community].merge subdomain: Community.name_deduced_subdomain(params[:community][:name])

    if @community_user.save
      create_invitations
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

  protected
    def create_invitations
      @community.user_emails.split(',').first(@community.max_users).each do |email|
        email = email.strip

        invite = @community.invites.build invitor: @user
        
        invitee = User.find_by_email(email)
        invitee ? invite.invitee = invitee : invite.invitee_email = email

        invite.save
      end
    end

end
