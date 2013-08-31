class EventsController < ApplicationController
  EVENT_TYPES = [RepeatableEvent, SingleOccurrenceEvent]

  add_crumb(lambda {|instance| instance.t('breadcrumbs.communities')}) { |instance| instance.send :communities_path }
  before_filter :find_community
  before_filter :set_breadcrumbs, only: [:index, :show, :new, :edit]

  def new
    add_crumb(t('breadcrumbs.new'), new_community_event_path(@community))
    @event = event_type.new
  end

  protected

  def set_breadcrumbs
    set_community_breadcrumb
    add_crumb t('breadcrumbs.events'), community_events_path(@community)
  end

  def event_type
    if params.has_key?(:type) && EVENT_TYPES.include?(params[:type].camelize)
      params[:type].camelize.constantize
    else
      RepeatableEvent
    end
  end
end
