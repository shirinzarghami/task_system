class Payment < ActiveRecord::Base
  require 'include/dynamic_attributes'
  include DynamicAttributes
  attr_accessible :community_user_id, :date, :description, :dynamic_attributes, :title, :type

  belongs_to :community_user #Creator
  has_one :community, through: :community_user

  has_many :user_saldo_modifications, dependent: :destroy

end
