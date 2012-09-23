class Task < ActiveRecord::Base
  attr_accessible :allocated_user_id, :allocation_mode, :deadline, :description, :interval, :last_occurrence, :name, :repeat, :should_be_checked, :start_on, :time, :user_id, :user_order, :instantiate_automatically, :interval_number, :interval_unit, :repeat_infinite, :deadline_number, :deadline_unit
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
    months: 1.month
  }
  after_initialize :set_time_units
  before_save :convert_time
  def set_time_units
    self.interval_unit, interval_unit_int = calculate_time_unit interval
    self.interval_number = interval / interval_unit_int
   
    self.deadline_unit, deadline_unit_int = calculate_time_unit deadline
    self.deadline_number = deadline / deadline_unit_int
    
  end

  def convert_time
    self.interval = TIME_UNITS[interval_unit.to_sym] * interval_number.to_i if defined? interval_unit
    self.deadline = TIME_UNITS[deadline_unit.to_sym] * deadline_number.to_i if defined? deadline_unit
  end

  def instantiate_in_words
    # set_time_units
    t_root = 'activerecord.attributes.task.instantiate'
    if instantiate_automatically 
      I18n.t("#{t_root}.every", number: self.interval_number, unit: I18n.t("#{t_root}.#{self.interval_unit}"))
    else
      I18n.t("#{t_root}.manual")
    end
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
