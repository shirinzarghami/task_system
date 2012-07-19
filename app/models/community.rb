class Community < ActiveRecord::Base
  attr_accessible :name, :subdomain, :user_tokens, :admin_user_tokens
  attr_reader :user_tokens, :admin_user_tokens

  has_many :community_users
  has_many :users, through: :community_users, conditions: ['role = ?', 'normal']
  has_many :admin_users, through: :community_users, class_name: 'User', source: :user, conditions: ['role = ?', 'admin']

  validates :name, presence: true, length: {maximum: 15, minimum: 3}, format: { :with => /^[A-Za-z\d_]+$/}
  validates :subdomain, presence: true, uniqueness: true, length: {maximum: 15, minimum: 3}, format: { :with => /^[a-z\d_]+$/}

  #TODO At least one user

  def user_tokens= ids
    self.user_ids = ids.split(',')
  end

  def admin_user_tokens= ids
    # self.admin_user_ids = ids.split(',')
     ids.split(',').each { |id| self.community_users.build user_id: id, role: 'admin'} 
  end


end
