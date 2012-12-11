class Invitation < ActiveRecord::Base
  attr_accessible :community_id, :invitee, :invitee_email, :invitor, :community, :invitation_emails
  
  STATUS = [:requested, :denied, :accepted]
  # Dummy variable for form
  attr_accessor :invitation_emails

  belongs_to :community
  belongs_to :invitor, class_name: 'User'
  belongs_to :invitee, class_name: 'User'

  # validates :community_id, presence: true
  validates :invitor, presence: true
  validates :community_id, presence: true
  validates :invitee_email, format:  {with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/}, allow_blank: true
  validates :status, presence: true, :inclusion => { :in => Invitation::STATUS.map(&:to_s) }
  after_create :send_invitation_email
  before_create :generate_token
  after_initialize :set_default_values

  scope :requested, where(['status = ?', 'requested'])
  def send_invitation_email
    InvitationMailer.invitation(self).deliver
  end

  def generate_token
    self.token = SecureRandom.hex(15)
  end

  def invitation_email= email
    self[:invitation_email] = email
    self.invitee = User.find_by_email email
  end

  def create_invitations_from invitor
    @community = invitor.communities.find(community)
    @community.build_invitations(invitor, self.invitation_emails)
    # Return the save result and set error when necessary
    @community.save or !set_community_errors
  end

  def deny
    self.status = 'denied'
    save
  end

  def accept user
    if user.email == invitee_email or invitee.nil?
      ActiveRecord::Base.transaction do
        if user.new_record?
          user.skip_confirmation! if user.email == invitee_email
          invitee = user
          invitee_email = user.email
          user.save!
        end
        CommunityUser.create! user: user, role: 'normal', community: community
        self.status = 'accepted'
        save!
      end
    else
      false
    end
  end

  private
    def set_community_errors
      @community.errors.select {|e| e.first == :invitations}.each {|e| self.errors.add(:invitation_emails, e.last)}
    end

    def set_default_values
      self.status ||= 'requested'
    end

end
