class InvitationsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:edit]
  before_filter :find_invitation, only: [:destroy]
  before_filter :find_invitation_by_token, only: [:edit, :update]
  before_filter :destroy_allowed, only: [:destroy]

  # before_filter :accept_allowed?, only: [:accept]
  # before_filter :accept_new_account_allowed?, only: [:accept_new_account]
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
    @user = (@invitation.invitee ? @invitation.invitee : User.new(email: @invitation.invitee_email))
  end

  def update
    if params[:invitation] == 'accept'
      @user = params.has_key?(:user) ? 
    elsif params[:invitation] == 'deny'
      if @invitation.deny
        flash[:notice] = t('invitations.flashed.denied')
        redirect_to invitation_path(@invitation)
      end
    else
      flash[:error] = t('invitations.flashed.select_error')
      render action: 'edit'
    end
  end

  def show
    
  end
  # Existing account
  # def accept
  #   begin
  #     ActiveRecord::Base.transaction do
  #       @community_user = CommunityUser.new user: current_user, role: 'normal', community: @community
  #       @community_user.save! if params[:invitation] == 'accept'
  #       @invitation.destroy
  #     end
  #     flash[:notice] = (params[:invitation] == 'accept' ? t('messages.accept_success', community: @community.name) : t('messages.deny_success', community: @community.name)) 
  #     redirect_to community_path(@community)
  #   rescue ActiveRecord::RecordInvalid => invalid
  #     flash[:error] = t('messages.accept_fail', community: @community.name)
  #     redirect_to (params[:invitation] == 'accept' ? community_path(@community) : communities_path)
  #   end

  # end
  # # Accept and create a new account
  # def accept_new_account
  #   @user = User.new params[:user]
  #   @community_user = CommunityUser.new user: @user, role: 'normal', community: @community
    
  #   begin
  #     ActiveRecord::Base.transaction do
  #       @user.skip_confirmation! if @user.email == @invitation.invitee_email
  #       @user.save!
  #       @community_user.save!
  #       @invitation.destroy
  #     end
  #     sign_in(@user)
  #     redirect_to community_path(@community)
  #     flash[:notice] = t('messages.accept_success', community: @community.name) 
  #   rescue ActiveRecord::RecordInvalid => invalid
  #     render action: 'show'
  #   end
  # end


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
      check @invitation.invitor == current_user or community_admin?(@community)
    end

    def user_params
      if @invitation.invitee.nil?
        params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, :name)
      else

      end
    end

    # def accept_allowed?
    #   redirect unless (current_user and @invitation.invitee.nil?) or (current_user.email == @invitation.invitee_email)
    # end

    # def accept_new_account_allowed?
    #   if @invitation.invitee
    #     redirect_to new_user_session_path
    #   end
    # end


end
