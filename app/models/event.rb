class Event < ActiveRecord::Base
  ActiveRecord::Base.send(:include, ActiveModel::ForbiddenAttributesProtection)
  attr_accessible :active, :community_user_id, :description, :destroyed, :name, :type, :repeatable_item_attributes, :event_roles_attributes
  # TODO: Mass assignment protection is off. Check whether strong parameters is used!!!

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
