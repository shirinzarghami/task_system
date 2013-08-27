class Event < ActiveRecord::Base
  EVENT_TYPES = [RepeatableEvent, SingleOccurrenceEvent]

  attr_accessible :active, :community_user_id, :description, :destroyed, :name, :type

  belongs_to :community_user # Creator
  has_one :community, through: :community_user 
  has_one :user, through: :community_user #creator

  
  validates :name, presence: true
end
