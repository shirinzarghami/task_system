class RepeatableItem < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  UNIT_VALUES = ['days','weeks', 'months', 'years', 'hours']
  WEEK_DAY_VALUES = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']
  
  TIME_UNITS = {
    days: 1.day,
    weeks: 1.week,
    months: 1.month
  }

  attr_accessible :deadline_number, :deadline_unit, :has_deadline, :next_occurrence, :only_on_week_days, :repeat_every_number, :repeat_every_unit, :repeat_infinite, :repeat_number, :repeatable_id, :repeatable_type

  belongs_to :repeatable, polymorphic: true

  validates :repeat_every_number, presence: true, :numericality => {:greater_than_or_equal_to => 0}
  validates :repeat_every_unit, presence: true, inclusion: {in: UNIT_VALUES}
  validates :deadline_number, presence: true, :numericality => {:greater_than_or_equal_to => 0}
  validates :deadline_unit, presence: true, inclusion: {in: UNIT_VALUES}
  validates :repeat_number, presence: true, :numericality => {:greater_than_or_equal_to => 0}
  validates :next_occurrence, presence: true

  validate :validate_only_on_week_days

  scope :to_schedule, lambda {where(['next_occurrence <= ?', Time.now.utc]).where(["repeat_infinite = ? OR repeat_number > ?", true, 0])}

  after_initialize :set_default_values

  def self.schedule_upcoming
    RepeatableItem.to_schedule.each do |repeatable_item|
      # begin
        repeatable_item.repeat!

      # rescue
      #   Rails.application.config.cron_job_logger.warn "Could not repeat #{repeatable_item.repeatable.class} with id = #{repeatable_item.repeatable.id}"
      # end
    end
  end

  def repeat!
    ActiveRecord::Base.transaction do
      repeatable.repeat!
      self.next_occurrence += repeat_every
      self.repeat_number -= 1 unless repeat_infinite || repeat_number == 0 
      save!
    end
  end

  def repeat_every
    eval "#{repeat_every_number}.#{repeat_every_unit}" if TIME_UNITS.keys.include?(repeat_every_unit.to_sym)
  end

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
