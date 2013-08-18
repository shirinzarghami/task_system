class Event < ActiveRecord::Base
  attr_accessible :active, :community_user_id, :description, :destroyed, :name, :type

  belongs_to :community_user # Creator
  belongs_to :community, through: :community_user 
  belongs_to :user, through: :community_user #creator

  
  validates :name, presence: true
end
