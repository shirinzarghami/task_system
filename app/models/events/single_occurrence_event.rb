class SingleOccurrenceEvent < Event
  include ActiveModel::ForbiddenAttributesProtection
  has_one :event_occurrence, dependent: :destroy

  
end