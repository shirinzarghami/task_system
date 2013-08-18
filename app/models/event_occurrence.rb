class EventOccurrence < ActiveRecord::Base
  attr_accessible :event_id, :register_deadline, :starts_at

  belongs_to :event

  validates :starts_at, presence: true
  validates :event_id, presence: true
end
