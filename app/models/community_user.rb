class CommunityUser < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  ROLES  =%w(normal admin)
  attr_accessible :community_id, :role, :user_id, :user, :community #Replaced by strong parameters

  belongs_to :user
  belongs_to :community

  has_many :payments, dependent: :destroy
  has_many :user_saldo_modifications, dependent: :destroy

  validates :community_id, uniqueness: {scope: :user_id}
  validates :role, inclusion: {:in => ROLES}
  validate :validate_at_least_one_admin

  before_destroy :destroy_has_at_least_one_admin?
  before_create :set_start_saldo

  scope :administrators, where(role: 'admin')
  scope :exclude, lambda {|community_user| where(['community_users.id != ?', community_user.id]) unless community_user.new_record?}

  def role_in_words
    I18n.t("activerecord.values.#{self.role}")
  end

  def admin?
    self.role == 'admin'
  end

  def normal?
    self.role == 'normal'
  end

  def saldo
    user_saldo_modifications.sum(:price)
  end


  protected
  def set_start_saldo
    community.start_saldo_distribution.user_saldo_modifications.build community_user: self, price: 0, percentage: 0     
  end

  def validate_at_least_one_admin
    community_users = community.present? ? community.community_users.administrators.exclude(self) : []
    errors.add(:base, :at_least_one_admin) unless community_users.count > 0 or self.role == 'admin'
  end

  def destroy_has_at_least_one_admin?
    community_users = community.community_users.administrators.exclude(self)
    errors.add(:base, :at_least_one_admin) unless community_users.count > 0
    errors.blank?
  end

    

end
