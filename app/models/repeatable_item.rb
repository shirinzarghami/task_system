class RepeatableItem < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  UNIT_VALUES = ['days','weeks', 'months', 'years', 'hours']
  WEEK_DAY_VALUES = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']
  
  TIME_UNITS = {
    days: 1.day,
    weeks: 1.week,
    months: 1.month
  }

  belongs_to :repeatable, polymorphic: true

  validates :repeat_every_number, presence: true, :numericality => {:greater_than_or_equal_to => 1}
  validates :repeat_every_unit, presence: true, inclusion: {in: UNIT_VALUES}
  validates :deadline_number, presence: true, :numericality => {:greater_than_or_equal_to => 1}
  validates :deadline_unit, presence: true, inclusion: {in: UNIT_VALUES}
  validates :repeat_number, presence: true, :numericality => {:greater_than_or_equal_to => 0}
  validates :next_occurrence, presence: true

  validate :validate_only_on_week_days

  scope :to_schedule, lambda {where(['next_occurrence <= ?', Time.now.utc]).where(["repeat_infinite = ? OR repeat_number > ?", true, 0]).where(:enabled => true)}

  after_initialize :set_default_values

  def self.schedule_upcoming
    RepeatableItem.to_schedule.each do |repeatable_item|
      begin
        repeatable_item.repeat!
      rescue
        Rails.application.config.cron_job_logger.warn "Could not repeat #{repeatable_item.repeatable.class} with id = #{repeatable_item.repeatable.id}"
      end
    end
  end

  def repeat!
    ActiveRecord::Base.transaction do
      repeatable.repeat!
      set_next_occurrence_from(self.next_occurrence)
      self.repeat_number -= 1 unless repeat_infinite || repeat_number == 0 
      save!
    end
  end

  def repeat_every
    eval "#{repeat_every_number}.#{repeat_every_unit}" if TIME_UNITS.keys.include?(repeat_every_unit.to_sym)
  end

  def set_next_occurrence_from start_date
    self.next_occurrence = start_date + repeat_every
  end

  protected
  def set_default_values
    self.repeat_every_unit ||= 'weeks'
    self.repeat_number ||= 0
    self.repeat_infinite = true if self.repeat_infinite.nil?
    self.next_occurrence ||= Time.now
    self.only_on_week_days ||= ''
    self.repeat_every_number = 1 if self.repeat_every_number
    self.deadline_unit ||= 'days'
    self.deadline_number = 1 if self.deadline_number
    self.has_deadline = true if self.has_deadline.nil?
  end

  def validate_only_on_week_days
    self.error.add(:only_on_week_days, :invalid) if self.only_on_week_days.split(',').reject {|day| WEEK_DAY_VALUES.include?(day) || day.blank? }.any?
  end

end
