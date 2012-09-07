class Invitation < ActiveRecord::Base
  attr_accessible :community_id, :invitee, :invitee_email, :invitor, :community, :invitation_emails

  belongs_to :community
  belongs_to :invitor, class_name: 'User'
  belongs_to :invitee, class_name: 'User'

  # validates :community_id, presence: true
  validates :invitor, presence: true
  validates :invitee_email, format:  {with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/}, allow_blank: true

  after_create :send_invitation_email
  before_create :generate_token

  def send_invitation_email
    InvitationMailer.invitation(self).deliver
  end

  def generate_token
    self.token = SecureRandom.hex(15)
  end

  # Dummy variable for form
  def invitation_emails
    @invitation_emails
  end

  def invitation_emails= emails
    @invitation_emails = emails
  end

end
