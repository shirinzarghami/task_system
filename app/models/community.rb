class Community < ActiveRecord::Base
  extend FriendlyId
    friendly_id :subdomain

  attr_accessible :name, :subdomain, :user_tokens, :admin_user_tokens, :max_users, :invitation_emails
  attr_reader :user_tokens, :admin_user_tokens

  has_many :community_users, dependent: :destroy
  has_many :invitations, dependent: :destroy

  # All users
  has_many :members, through: :community_users, class_name: 'User', source: :user
  # Only normal user
  has_many :users, through: :community_users, conditions: ['role = ?', 'normal']
  # Administrators
  has_many :admin_users, through: :community_users, class_name: 'User', source: :user, conditions: ['role = ?', 'admin']

  validates :name, presence: true, length: {maximum: 20, minimum: 3}, format: { :with => /^[A-Za-z\d_\s]+$/}
  validates :subdomain, presence: true, uniqueness: true, length: {maximum: 20, minimum: 3}, format: { :with => /^[a-z\d_\-]+$/}

  before_validation :deduce_subdomain
  after_validation :set_invitation_errors


  # Token input railscast 258
  def user_tokens= ids
    self.user_ids = ids.split(',')
  end

  def admin_user_tokens= ids
     id_list = ids.split(',')
     # Remove old entries
     ((self.admin_users.map(&:id)) - id_list).each {|user_id| self.admin_users.delete(User.find(user_id))}
     id_list.each { |id| self.community_users.build user_id: id, role: 'admin'} 
  end

  # Creates invitations for these emails
  def invitation_emails= emails, invitor = nil
    @invitation_emails = emails
  end

  def invitation_emails
    @invitation_emails
  end

  def deduce_subdomain
    self.subdomain = name.downcase.gsub(/[^a-z0-9\-_]/, '-').truncate(20, omission: '') if self.subdomain.nil?
  end

  def invite invitor, email_list = []
    @invitation_emails = email_list if email_list.any?
    @invitation_emails.split(',').first(20).map(&:strip).each do |email|
      invitee = User.find_by_email email
      params = invitee.present? ? {invitee: invitee} : {}
      self.invitations.build params.merge(invitor: invitor, invitee_email: email)
    end
  end

  protected
    def set_invitation_errors
      self.errors.select {|e| e.first == :invitations}.each {|e| self.errors.add(:invitation_emails, e.last)}
    end


end
