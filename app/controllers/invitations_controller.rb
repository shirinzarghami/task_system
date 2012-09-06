class InvitationsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:show, :accept_new_account]
  def new
  end

  def create
  end

  def destroy
    @invitation = @community.invitations.find params[:id]

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
  end

  def accept_new_account
    
  end

  def show
    @community = Community.find params[:community_id]
    @invitation = Invitation.find_by_token(params[:id])
    @user = (@invitation.invitee ? @invitation.invitee : User.new(email: @invitation.invitee_email))
 
    # User ingelogd == email invitation ==> accept scherm
    # User ingelogd != email invitation maar WEL bestaande user ==> login als andere user
    # User ingelogd != email invitation en een NIET bestaande user ==> Accept scherm als andere user
    # Geen user inglogd  en invitation_email bestaat WEL ==> login als andere user
    # Geen user inglogd  en invitation_email bestaat NIET ==> create nieuwe user


  end

  def index
  end
end
