class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :global_role, :locale
  # attr_accessible :title, :body
  validates :name, presence: true, length: {minimum: 2, maximum: 40}
  validates :email, presence: true, length: {minimum: 2, maximum: 40}
  validates :global_role, presence: true
  # has_and_belongs_to_many :communities
  has_many :community_users, dependent: :destroy
  has_many :communities, through: :community_users
  has_many :created_communities, class_name: 'Community', foreign_key: 'creator_id'
  has_many :admin_communities, through: :community_users, source: :community, class_name: 'Community', conditions: ['role = ?', 'admin']
  has_many :normal_communities, through: :community_users, source: :community,class_name: 'Community', conditions: ['role = ?', 'normal']

  has_many :invitation_requests, class_name: 'Invitation', foreign_key: 'invitor_id', dependent: :destroy
  has_many :invitations, class_name: 'Invitation', foreign_key: 'invitee_id', dependent: :destroy

  has_many :tasks
  has_many :task_occurrences
  has_many :allocated_tasks, class_name: 'Task', foreign_key: 'allocated_user_id'

  scope :unconfirmed, where("confirmed_at IS NULL")
  USER_ROLES = [:normal, :admin]

  def confirmed?
    confirmed_at.present?
  end

end
