class InvitationsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:show, :accept_new_account, :accept]
  skip_before_filter :find_community
  before_filter :find_invitation_by_token, only: [:accept, :accept_new_account, :show]
  before_filter :accept_allowed?, only: [:accept]
  before_filter :accept_new_account_allowed?, only: [:accept_new_account]

  def new
    @communities = current_user.communities
    @invitation = Invitation.new
  end

  def create
  end

  def destroy
    @invitation = Invitation.find params[:id]
    @community = @invitation.community
    if @invitation.destroy
      flash[:notice] = t('messages.delete')
      redirect_to community_path(@community)
    else
      flash[:notice] = t('messages.delete_fail')
      redirect_to community_path(@community)
    end
  end

  # Existing account
  def accept
    begin
      ActiveRecord::Base.transaction do
        @community_user = CommunityUser.new user: current_user, role: 'normal', community: @community
        @community_user.save! if params[:invitation] == 'accept'
        @invitation.destroy
      end
      flash[:notice] = (params[:invitation] == 'accept' ? t('messages.accept_success', community: @community.name) : t('messages.deny_success', community: @community.name)) 
      redirect_to community_path(@community)
    rescue ActiveRecord::RecordInvalid => invalid
      flash[:notice] = t('messages.accept_fail', community: @community.name)
      redirect_to community_path(@community)
    end

  end

  def accept_new_account
    @user = User.new params[:user]
    @community_user = CommunityUser.new user: @user, role: 'normal', community: @community
    
    begin
      ActiveRecord::Base.transaction do
        @user.skip_confirmation! if @user.email == @invitation.invitee_email
        @user.save!
        @community_user.save!
        @invitation.destroy
      end
      sign_in(@user)
      flash[:notice] = t('messages.accept_success', community: @community.name) 
    rescue ActiveRecord::RecordInvalid => invalid
      render action: 'show'
    end
  end

  def show
    @user = (@invitation.invitee ? @invitation.invitee : User.new(email: @invitation.invitee_email))
  end

  def index
  end

  protected
    def find_invitation_by_token
      @invitation = Invitation.find_by_token(params[:id])
      if @invitation.nil?
        redirect_to (current_user ? communities_path : new_user_session_path)
      end
      @community = @invitation.community
    end

    def accept_allowed?
      unless (current_user and @invitation.invitee.nil?) or (current_user.email == @invitation.invitee_email)
        redirect_to (current_user ? communities_path : new_user_session_path)
      end
    end

    def accept_new_account_allowed?
      if @invitation.invitee
        redirect_to new_user_session_path
      end
    end
end
