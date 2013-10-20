class StartSaldoDistribution < ActiveRecord::Base
  attr_accessible :community_id

  belongs_to :community

  has_many :user_saldo_modifications, as: :chargeable

  accepts_nested_attributes_for :user_saldo_modifications
  
end
