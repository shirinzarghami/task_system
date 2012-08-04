class Invite < ActiveRecord::Base
  attr_accessible :community_id, :invitee, :invitee_email, :invitor

  belongs_to :community
  belongs_to :invitor, class_name: 'User'
  belongs_to :invitee, class_name: 'User'

  validates :community_id, presence: true
  validates :invitor, presence: true
  # validates :invitee_email, format:  {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}



end
