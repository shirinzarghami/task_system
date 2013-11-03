class Invitation < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  attr_accessible :community_id, :invitee, :invitee_email, :invitor, :community, :invitation_emails
  
  STATUS = [:requested, :denied, :accepted]
  # Dummy variable for form
  attr_accessor :invitation_emails

  belongs_to :community, validate: true
  belongs_to :invitor, class_name: 'User'
  belongs_to :invitee, class_name: 'User'

  validates :invitor, presence: true
  validates :invitee_email, format:  {with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/}, allow_blank: true
  validates :status, presence: true, :inclusion => { :in => Invitation::STATUS.map(&:to_s) }

  after_create :send_invitation_email
  before_create :generate_token
  after_initialize :set_default_values

  scope :requested, where(status: 'requested')
  
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
    return false unless (user.email == invitee_email or invitee.nil?)
    begin
      ActiveRecord::Base.transaction do
        if user.new_record?
          user.skip_confirmation! if user.email == invitee_email
          invitee = user
          invitee_email = user.email
          user.save!
        end
        community_user = CommunityUser.new
        community_user.user = user
        community_user.role = 'normal'
        community_user.community = community
        
        start_saldos = community.start_saldo_distribution
        start_saldos.user_saldo_modifications.build community_user: community_user, price: 0, percentage: 0
        self.status = 'accepted'

        community_user.save!
        start_saldos.save!
        save!
      end
    rescue
      self.community.errors.messages.to_a.map{|m|m.last.last}.uniq.each do |message|
        self.errors.add(:base, message)
      end
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
