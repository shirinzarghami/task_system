class TaskOccurrencesController < ApplicationController
  def index
    @my_todos = TaskOccurrence.for_user(@user).for_community(@community)
  end

  def create
    
  end
end
