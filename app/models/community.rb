class Community < ActiveRecord::Base
  attr_accessible :name, :subdomain, :user_tokens, :admin_user_tokens, :max_users
  attr_reader :user_tokens, :admin_user_tokens

  has_many :community_users, dependent: :destroy

  has_many :members, through: :community_users, class_name: 'User', source: :user
  # Only normal user
  has_many :users, through: :community_users, conditions: ['role = ?', 'normal']
  has_many :admin_users, through: :community_users, class_name: 'User', source: :user, conditions: ['role = ?', 'admin']

  validates :name, presence: true, length: {maximum: 20, minimum: 3}, format: { :with => /^[A-Za-z\d_]+$/}
  validates :subdomain, presence: true, uniqueness: true, length: {maximum: 20, minimum: 3}, format: { :with => /^[a-z\d_]+$/}


  #TODO At least one user

  # Token input railscast 258
  def user_tokens= ids
    self.user_ids = ids.split(',')
  end

  def admin_user_tokens= ids
     id_list = ids.split(',')
     # Remove old entries
     ((self.admin_users.map(&:id)) - id_list).each {|user_id| self.admin_users.delete(User.find(user_id))}
     id_list.each { |id| self.community_users.build user_id: id, role: 'admin'} 
  end
end
