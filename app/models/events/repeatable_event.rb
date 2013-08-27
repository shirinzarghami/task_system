class RepeatableEvent < Event
  has_many :event_occurrences, dependent: :destroy
  has_one :repeatable_item, as: :repeatable, dependent: :destroy

  accepts_nested_attributes_for :repeatable_item

end