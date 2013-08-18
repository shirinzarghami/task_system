class InvitationMailer < ActionMailer::Base
  extend MailerHelper
  default from: default_from
  

  def invitation invitation
    @invitation = invitation
    @invitee_name = @invitation.invitee.nil? ? @invitation.invitee_email : @invitation.invitee.name
    mail to: @invitation.invitee_email do |format|
      format.html { render :layout => 'email' }
      # format.text
    end
  end
end
