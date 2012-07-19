class CommunityUser < ActiveRecord::Base
  attr_accessible :community_id, :role, :user_id

  belongs_to :user
  belongs_to :community
end
