class RepeatableItem < ActiveRecord::Base
  UNIT_VALUES = ['days','weeks', 'months', 'years']
  WEEK_DAY_VALUES = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']
  attr_accessible :deadline_number, :deadline_unit, :has_deadline, :next_occurrence, :only_on_week_days, :repeat_every_number, :repeat_every_unit, :repeat_infinite, :repeat_number, :repeatable_id, :repeatable_type

  belongs_to :repeatable, polymorphic: true

  validates :repeat_every_number, presence: true, :numericality => {:greater_than_or_equal_to => 0}
  validates :repeat_every_unit, presence: true, inclusion: {in: UNIT_VALUES}

  validates :deadline, presence: true, :numericality => {:greater_than_or_equal_to => 0}
  validates :deadline_number, presence: true, inclusion: {in: UNIT_VALUES}
  
  validates :repeat_number, presence: true, :numericality => {:greater_than_or_equal_to => 0}
  validates :next_occurrence, presence: true
  
  validates :repeatable_id, presence: true
  validates :repeatable_type, presence: true

  validate :validate_only_on_week_days


  after_initialize :set_default_values

  protected

  def set_default_values
    self.repeat_every_unit ||= 'days'
    self.repeat_number ||= 0
    self.repeat_infinite = true if self.repeat_infinite.nil?
    self.next_occurrence ||= Time.now
    self.only_on_week_days ||= ''
    self.repeat_every_number ||= 1
    self.deadline_unit ||= 'days'
    self.deadline_number ||= 1
    self.has_deadline = true if self.has_deadline.nil?
  end

  def validate_only_on_week_days
    self.error.add(:only_on_week_days, :invalid) if self.only_on_week_days.split(',').reject {|day| WEEK_DAY_VALUES.include?(day) || day.blank? }.any?
  end

end
