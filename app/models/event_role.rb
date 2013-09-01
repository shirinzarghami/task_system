class EventRole < ActiveRecord::Base
  attr_accessible :event_id, :has_task_occurrence, :max_users, :name, :time

  belongs_to :event

  after_initialize :set_default_values

  protected

  def set_default_values
    self.max_users ||= 10
    self.time ||= 0
    self.has_task_occurrence = false if has_task_occurrence.nil?
  end
end
