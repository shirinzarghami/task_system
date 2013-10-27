class StartSaldoDistribution < ActiveRecord::Base
  include Chargeable::Validations
  attr_accessible :community_id, :user_saldo_modifications_attributes

  belongs_to :community
  has_many :user_saldo_modifications, as: :chargeable

  accepts_nested_attributes_for :user_saldo_modifications
  
  validate :result_is_zero


  protected
  def result_is_zero
    super self.user_saldo_modifications.map(&:price).inject {|sum, price| sum + price}
  end

end
