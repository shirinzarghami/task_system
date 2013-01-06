class CommentsController < ApplicationController
  before_filter :load_commentable, only: [:create]
  before_filter :find_community

  def index
  end

  def create
    @comment = Comment.build_from(@commentable, current_user, params[:comment][:body])
    if @comment.save
      redirect_to return_url
    else
      flash[:error] = t('messages.error')
      redirect_to return_url
    end
  end

  def update
  end

  private
    def return_url
      if @commentable.class == TaskOccurrence
        community_task_occurrence_path(@community, @commentable)
      else
        community_path(@community)
      end
    end
end
