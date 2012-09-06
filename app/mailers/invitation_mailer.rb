class InvitationMailer < ActionMailer::Base
  default from: "administrator@tasksystem.com"
  # layout 'mail'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.invitation_mailer.invitation.subject
  #
  def invitation invitation
    @invitation = invitation
    @invitee_name = @invitation.invitee.nil? ? @invitation.invitee_email : @invitation.invitee.name
    mail to: @invitation.invitee_email
  end
end
