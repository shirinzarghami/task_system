class InvitationsController < ApplicationController
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

  def accept
  end

  def index
  end
end
