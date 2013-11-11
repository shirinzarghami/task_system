class EventsController < ApplicationController
  EVENT_TYPES = [RepeatableEvent, SingleOccurrenceEvent]

  add_crumb(lambda {|instance| instance.t('breadcrumbs.communities')}) { |instance| instance.send :communities_path }
  before_filter :find_community
  before_filter :set_breadcrumbs, only: [:index, :show, :new, :edit]

  def new
    add_crumb(t('breadcrumbs.new'), new_community_event_path(@community))
    @event = event_type_class.new
  end

  def create
    @event = event_type_class.new event_params
    debugger
    if @event.save
      flash[:notice] = t('messages.save_success')
      redirect_to community_events_path @community
    else
      flash[:error] = t('messages.save_fail')
      render 'edit'
    end
  end

  protected

  def set_breadcrumbs
    set_community_breadcrumb
    add_crumb t('breadcrumbs.events'), community_events_path(@community)
  end

  def event_type_class
    klass = params[:type] || event_type || 'repeatable_event'
    EVENT_TYPES.include?(klass.to_s.camelize) ? klass.camelize.constantize : RepeatableEvent
  end

  def event_type
    event_types                 = [:event, :repeatable_event]
    event_types.select {|type| params.has_key? type}.first
  end

  def event_params
    repeatable_item_attributes  = [:deadline_number, :deadline_unit, :has_deadline, :next_occurrence, :only_on_week_days, :repeat_every_number, :repeat_every_unit, :repeat_infinite, :repeat_number]
    event_roles_attributes      = [:has_task_occurrence, :max_users, :name, :time]
    event_attributes            = [:active, :description, :destroyed, :name, :type]

    allowed_event_attributes    = [event_attributes, {repeatable_item_attributes: repeatable_item_attributes, event_roles_attributes: event_roles_attributes}].flatten
    params.require(event_type).permit(*allowed_event_attributes)
  end

end
