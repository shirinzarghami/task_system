class CommunityUser < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  attr_accessible :community_id, :role, :user_id, :user, :community

  belongs_to :user
  belongs_to :community

  validates :community_id, uniqueness: {scope: :user_id}
end
