class Invitation < ActiveRecord::Base
  attr_accessible :community_id, :invitee, :invitee_email, :invitor, :community

  belongs_to :community
  belongs_to :invitor, class_name: 'User'
  belongs_to :invitee, class_name: 'User'

  # validates :community_id, presence: true
  validates :invitor, presence: true
  validates :invitee_email, format:  {with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/}, allow_blank: true



end
