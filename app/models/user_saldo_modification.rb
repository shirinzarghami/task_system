class UserSaldoModification < ActiveRecord::Base
  attr_accessible :community_user_id, :payment_id, :price, :community_user

  belongs_to :payment
  belongs_to :community_user
  has_one :user, through: :community_user
end
