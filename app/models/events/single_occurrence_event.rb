class SingleOccurrenceEvent < Event
  has_one :event_occurrence, dependent: :destroy

  
end