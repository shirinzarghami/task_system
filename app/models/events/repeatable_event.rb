class RepeatableEvent < Event
  has_many :event_occurrences, dependent: :destroy
  has_one :repeatable_item, as: :repeatable, dependent: :destroy

  accepts_nested_attributes_for :repeatable_item

  after_initialize :set_default_values

  protected

  def set_default_values
    build_repeatable_item if self.repeatable_item.nil?
  end
end
