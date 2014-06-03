class CompensationsController < ApplicationController

  add_crumb(lambda {|instance| instance.t('breadcrumbs.communities')}) { |instance| instance.send :communities_path }
  before_filter :find_community

  def edit
    @community_user = CommunityUser.find params[:community_user_id]

    @task_occurrences = @community.tasks.map do |task|
      if task_occurrence = task.task_occurrences.compensations.where(user_id: @community_user.user.id).first
        task_occurrence
      else
        attributes = { user: @community_user.user, 
          is_compensation: true, 
          task_name: task.name,
          task_description: task.description,
          time_in_minutes: 0 }

        task.task_occurrences.build attributes
      end
    end
  end

  def update
    
  end
end