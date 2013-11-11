class Event < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :community_user # Creator
  has_one :community, through: :community_user 
  has_one :user, through: :community_user #creator
  has_many :event_roles, dependent: :destroy
  
  accepts_nested_attributes_for :event_roles

  validates :name, presence: true

  after_initialize :set_default_values

  protected

  def set_default_values
    event_roles.build
  end
end
