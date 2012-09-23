class Task < ActiveRecord::Base
  attr_accessible :allocated_user_id, :allocation_mode, :deadline, :description, :interval, :last_occurrence, :name, :repeat, :should_be_checked, :start_on, :time, :user_id, :user_order
  attr_accessor :interval_number, :interval_unit, :deadline_number, :deadline_unit
  belongs_to :community
  belongs_to :user # Creator of the task
  belongs_to :allocated_user, class_name: 'User'

  validates :name, presence: true, length: {maximum: 50, minimum: 3}
  validates :time, presence: true, :numericality => {:greater_than => 0}
  ALLOCATION_MODES = [:in_turns, :time, :time_all, :voluntary, :user]
  ALLOCATION_MODES_FORM = Task::ALLOCATION_MODES.map {|m| [I18n.t("activerecord.attributes.task.allocation_modes.#{m.to_s}"), m]} 

  TIME_UNITS = {
    days: 1.day,
    weeks: 1.week,
    month: 1.month
  }
  after_initialize :set_time_units
  before_save :convert_time
  def set_time_units
    interval ||= 0
    deadline ||= 0
    unless defined? @interval_number
      @interval_unit, interval_unit_int = calculate_time_unit interval
      @interval_number = interval / interval_unit_int
    end

    unless defined? @deadline_number
      @deadline_unit, deadline_unit_int = calculate_time_unit deadline
      @deadline_number = deadline / deadline_unit_int
    end
  end

  def convert_time
    self.interval = TIME_UNITS[interval_unit] * interval_number if defined? interval_unit
    self.deadline = TIME_UNITS[deadline_unit] * deadline_number if defined? deadline_unit
  end

  # def interval_number
    
  # end

  # def interval_unit
    
  # end

  # def deadline_number
    
  # end

  # def deadline_unit
    
  # end

  def repeat_infinite
    
  end

  def user_order
    
  end

  protected
    def calculate_time_unit time
      if time % 1.month == 0
        unit = ['months', 1.month]
      elsif time % 1.week == 0
        unit = ['weeks', 1.week]
      else
        unit = ['days', 1.day]
      end
    end
end
