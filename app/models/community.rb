class Community < ActiveRecord::Base
  attr_accessible :name, :subdomain, :user_tokens
  attr_reader :user_tokens

  has_and_belongs_to_many :users
  validates :name, presence: true, length: {maximum: 15, minimum: 3}, format: { :with => /^[A-Za-z\d_]+$/}
  validates :subdomain, presence: true, uniqueness: true, length: {maximum: 15, minimum: 3}, format: { :with => /^[a-z\d_]+$/}

  #TODO At least one user

  def user_tokens= ids
    self.user_ids = ids.split(',')
  end
end
