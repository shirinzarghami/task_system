class TaskOccurrencesController < ApplicationController
  def index
    @my_todos = TaskOccurrence.for_user(@user).for_community(@community)
  end
end
