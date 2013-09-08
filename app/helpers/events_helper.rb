module EventsHelper
  def event_form_url
    if controller.action_name == 'update' || controller.action_name == 'edit'
      community_event_path(@community, @event.id)
    elsif controller.action_name == 'new' || controller.action_name == 'create'
      community_events_path(@community)
    end
  end
end