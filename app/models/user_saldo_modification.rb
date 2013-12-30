class UserSaldoModification < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  
  belongs_to :chargeable, polymorphic: true
  belongs_to :community_user
  has_one :user, through: :community_user
  has_one :community, through: :community_user

  after_initialize :set_initial_values

  # validates :payment_id, presence: true
  validates :price, presence: true
  validates :percentage, presence: true, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}

 
  def clone
    cloned_usm = self.dup
    cloned_usm.community = self.community
    cloned_usm.community_user = self.community_user
    cloned_usm
  end
    
  private
  def set_initial_values
    self.checked = false if self.checked.nil?
    self.percentage ||= 0
    self.price ||= 0
  end

end
