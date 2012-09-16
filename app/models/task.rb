class Task < ActiveRecord::Base
  attr_accessible :allocated_user_id, :allocation_mode, :community_id, :deadline, :description, :interval, :last_occurrence, :name, :repeat, :should_be_checked, :start_on, :time, :user_id, :user_order
  belongs_to :community
  belongs_to :user # Creator of the task
  belongs_to :allocated_user, class_name: 'User'

  ALLOCATION_MODES = [:in_turns, :time, :time_all, :voluntary, :user]
  ALLOCATION_MODES_FORM = Task::ALLOCATION_MODES.map {|m| [I18n.t("activerecord.attributes.task.allocation_modes.#{m.to_s}"), m]} 


  def interval_number
    
  end

  def interval_unit
    
  end

  def deadline_number
    
  end

  def deadline_unit
    
  end

  def repeat_infinite
    
  end
end
