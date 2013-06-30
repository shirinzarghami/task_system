class Payment < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection
  # require 'include/dynamic_attributes'
  # PERSIST_DYNAMIC_ATTRIBUTES = []
  # include DynamicAttributes
  attr_accessible :community_user_id, :date, :description, :dynamic_attributes, :title, :type, :user_saldo_modifications_attributes, :price, :categories
  attr_accessor :categories
  acts_as_taggable_on :categories

  belongs_to :community_user #Creator
  has_one :community, through: :community_user

  has_many :user_saldo_modifications, dependent: :destroy
  accepts_nested_attributes_for :user_saldo_modifications

  after_initialize :set_initial_values

  validates :title, presence: true
  validates :date, presence: true
  validates :price, presence: true, :numericality => {:greater_than => 0}
  validate :invalid_user

  # default_scope order('created_at DESC')
  
  acts_as_commentable

  def save_category_tags
    if @categories.present?
      ActsAsTaggableOn::Tagging.where(taggable_id: self.id, taggable_type: 'Payment', tagger_type: 'Community', tagger_id: community.id).destroy_all
      self.community.tag(self, :with => @categories.split(','), :on => :categories)
    end
  end

  private
    def set_initial_values
      self.price ||= 0
      self.date ||= Date.today
    end

    def invalid_user
      errors.add(:base, :invalid_user) unless self.user_saldo_modifications.reject {|usm| self.community.id == usm.community.id}.size == 0
    end

  
end
