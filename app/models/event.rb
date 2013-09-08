class Event < ActiveRecord::Base
  # attr_accessible :active, :community_user_id, :description, :destroyed, :name, :type, :repeatable_item_attributes
  # TODO: Mass assignment protection is off. Check whether strong parameters is used!!!

  belongs_to :community_user # Creator
  has_one :community, through: :community_user 
  has_one :user, through: :community_user #creator
  has_many :event_roles, dependent: :destroy
  
  validates :name, presence: true
end
