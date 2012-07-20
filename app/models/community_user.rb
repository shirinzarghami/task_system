class CommunityUser < ActiveRecord::Base
  attr_accessible :community_id, :role, :user_id

  belongs_to :user
  belongs_to :community

  validates :community_id, uniqueness: {scope: :user_id}
end
