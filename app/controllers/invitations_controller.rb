class InvitationsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:edit, :update, :show]
  before_filter :find_invitation, only: [:destroy]
  before_filter :find_invitation_by_token, only: [:edit, :update, :show]
  before_filter :destroy_allowed, only: [:destroy]

  def new
    @communities = current_user.communities
    @invitation_dummy = Invitation.new
  end

  def create
    @invitation_dummy = Invitation.new params[:invitation]

    if @invitation_dummy.create_invitations_from(@user)
      flash[:notice] = t('messages.invite_success')
      redirect_to communities_path
    else
      flash[:error] = t('messages.error')
      @communities = current_user.communities
      render action: 'new'
    end
  end

  def destroy
    if @invitation.destroy
      flash[:notice] = t('messages.delete')
      redirect_to community_path(@community)
    else
      flash[:error] = t('messages.delete_fail')
      redirect_to community_path(@community)
    end
  end

  def edit
    redirect_to invitation_path(@invitation.token) unless @invitation.status == 'requested'
    @user = (@invitation.invitee ? @invitation.invitee : User.new(email: @invitation.invitee_email))
  end

  def update
    @user = User.new user_params
    if params[:invitation] == 'accept'
      if @invitation.accept(current_user ? current_user : @user)
        sign_in(@user) if !current_user and @user.confirmed?
        flash[:notice] = t('messages.accept_invitation_success')
        if current_user
          redirect_to community_path(@invitation.community)
        else
          flash[:info] = t('messages.send_email_notice')
          redirect_to invitation_path(@invitation.token)
        end
      else
        flash[:error] = error_messages_for @invitation, t('messages.accept_invitation_fail')
        render action: 'edit'
      end
    elsif params[:invitation] == 'deny' and @invitation.deny
      flash[:notice] = t('invitations.flashes.denied')
      redirect_to invitation_path(@invitation.token)
    else
      flash[:error] = t('invitations.flashes.select_error')
      render action: 'edit'
    end
  end

  def show
    
  end

  private
    def find_invitation
      @invitation = Invitation.find params[:id]
      @community = @invitation.community
    end

    def find_invitation_by_token
      @invitation = Invitation.find_by_token!(params[:id])
      @community = @invitation.community
    end

    def destroy_allowed
      is_allowed = (@invitation.invitor == current_user or community_admin?(@community))
      check is_allowed
    end

    def user_params
      if @invitation.invitee.nil?
        params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, :name)
      end
    end

end
