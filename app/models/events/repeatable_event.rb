class RepeatableEvent < Event
  has_many :event_occurrences, dependent: :destroy
  has_one :repeatable_item as: :repeatable, dependent: :destroy



end