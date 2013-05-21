module CommunityUsersHelper

  def user_activity_distribution(community_user)
     start_date = community_user.user.task_occurrences.where(community_id: community_user.community.id).order(:created_at).first
     end_date = community_user.user.task_occurrences.where(community_id: community_user.community.id).order(:created_at).last

     interval = determine_interval_for start_date, end_date
     result = cu.user.task_occurrences.where(community_id: cu.community.id).order(:created_at).select('sum(time_in_minutes) as total').group('week(created_at)')
     # Created more task occurrences
     # 20.times {|i| t = TaskOccurrence.new(to.attributes.symbolize_keys.except(:id, :created_at, :updated_at, :should_send_assign_mail, :reminder_mail_sent, :community_id)) ; t.created_at = i.weeks.ago ; t.community = to.community ; t.save}
  end

  private
    def determine_interval_for(start_date, end_date)
      date_diff = end_date - start_date

      if date_diff > 5.year
        6.month
      elsif date_diff > 2.year
        1.month
      elsif date_diff > 6.month
        1.week
      else
        1.day
      end
    end
end
