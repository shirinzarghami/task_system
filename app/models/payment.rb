class Payment < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  # require 'include/dynamic_attributes'
  # PERSIST_DYNAMIC_ATTRIBUTES = []
  # include DynamicAttributes
  attr_accessible :community_user_id, :date, :description, :dynamic_attributes, :title, :type, :user_saldo_modifications_attributes, :price

  belongs_to :community_user #Creator
  has_one :community, through: :community_user

  has_many :user_saldo_modifications, dependent: :destroy
  accepts_nested_attributes_for :user_saldo_modifications

  after_initialize :set_initial_values

  validates :title, presence: true
  validates :date, presence: true
  validates :price, presence: true, :numericality => {:greater_than => 0}
  validate :invalid_user
  private
    def set_initial_values
      self.price ||= 0
    end

    def invalid_user
      errors.add(:base, :invalid_user) unless self.user_saldo_modifications.reject {|usm| self.community.id == usm.community.id}.size == 0
    end
  
end
