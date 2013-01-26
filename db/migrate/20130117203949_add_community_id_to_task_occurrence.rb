class AddCommunityIdToTaskOccurrence < ActiveRecord::Migration
  def change
    add_column :task_occurrences, :community_id, :integer
  end
end
