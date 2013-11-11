class EventOccurrence < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :event

  validates :starts_at, presence: true
  validates :event_id, presence: true
end
