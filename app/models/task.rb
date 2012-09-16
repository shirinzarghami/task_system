class Task < ActiveRecord::Base
  attr_accessible :allocated_user_id, :allocation_mode, :community_id, :deadline, :description, :interval, :last_occurrence, :name, :repeat, :should_be_checked, :start_on, :time, :user_id, :user_order
  belongs_to :community
  belongs_to :user # Creator of the task
  belongs_to :allocated_user, class_name: 'User'

  
  def interval_number
    
  end

  def interval_unit
    
  end

  def deadline_number
    
  end

  def deadline_unit
    
  end
end
