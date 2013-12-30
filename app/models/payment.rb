class Payment < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  attr_accessor :categories
  acts_as_taggable_on :categories

  belongs_to :community_user #Creator
  has_one :community, through: :community_user
  has_one :repeatable_item, as: :repeatable, dependent: :destroy
  has_many :user_saldo_modifications, dependent: :destroy, as: :chargeable

  belongs_to :parent, :class_name => 'Payment'
  has_many :childeren, :class_name => 'Payment'

  accepts_nested_attributes_for :user_saldo_modifications
  accepts_nested_attributes_for :repeatable_item

  after_initialize :set_initial_values

  validates :title, presence: true
  validates :payed_at, presence: true
  validates :price, presence: true, :numericality => {:greater_than => 0}
  validate :invalid_user

  acts_as_commentable

  def save_category_tags
    if @categories.present?
      ActsAsTaggableOn::Tagging.where(taggable_id: self.id, taggable_type: 'Payment', tagger_type: 'Community', tagger_id: community.id).destroy_all
      self.community.tag(self, :with => @categories.split(','), :on => :categories)
    end
  end

  # Makes url_for work with STI
  def self.model_name
    self == Payment ? ActiveModel::Name.new(Payment, nil, 'Payment') : Payment.model_name
  end

  def repeat!
    cloned_payment = self.clone
    cloned_payment.payed_at = Time.now
    cloned_payment.title = "#{title} - #{I18n.l(Date.today)}"
    cloned_payment.payment_id = self.id
    cloned_payment.save! && save!
  end

  def clone
    cloned_payment = self.dup
    user_saldo_modifications.each do |saldo_mod|
      cloned_payment.user_saldo_modifications.build saldo_mod.clone.attributes
    end
    cloned_payment
  end

  private
  def set_initial_values
    self.price ||= 0
    self.payed_at ||= Time.now
  end

  def invalid_user
    errors.add(:base, :invalid_user) unless self.user_saldo_modifications.reject {|usm| self.community.id == usm.community.id}.size == 0
  end

  
end
