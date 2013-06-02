class Payment < ActiveRecord::Base
  require 'include/dynamic_attributes'
  include DynamicAttributes
  attr_accessible :community_user_id, :date, :description, :dynamic_attributes, :title, :type

  belongs_to :community_user #Creator
  has_one :community, through: :community_user

  has_many :user_saldo_modifications, dependent: :destroy
  accepts_nested_attributes_for :user_saldo_modifications

  after_initialize :set_initial_values

  validates :title, presence: true
  validates :date, presence: true
  validates :price, presence: true, :numericality => {:greater_than_or_equal_to => 0}

  private
    def set_initial_values
      self.price ||= 0

    end
  
end
