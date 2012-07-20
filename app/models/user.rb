class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :global_role
  # attr_accessible :title, :body
  validates :name, presence: true, length: {minimum: 2, maximum: 40}
  validates :email, presence: true, length: {minimum: 2, maximum: 40}
  validates :global_role, presence: true
  # has_and_belongs_to_many :communities
  has_many :community_users, dependent: :destroy
  has_many :communities, through: :community_users

  USER_ROLES = [:normal, :admin]

end
