class CommentsController < ApplicationController
  before_filter :load_commentable
  before_filter :find_community
  before_filter :find_comment, only: [:destroy, :update]
  before_filter :check_destroy_allowed, only: [:destroy]

  def index
  end

  def create
    @comment = Comment.build_from(@commentable, current_user, params[:comment_body])
    if @comment.save
      redirect_to return_url
    else
      flash[:error] = t('messages.error')
      redirect_to return_url
    end
  end

  def update
  end

  def destroy
    if @comment.destroy

    else
      flash[:error] = t('messages.error')
      render 'shared/ajax_flash'
    end
  end

  private
    def return_url
      if @commentable.class == TaskOccurrence
        community_task_occurrence_path(@community, @commentable)
      else
        community_path(@community)
      end
    end

    def find_comment
      @object = @comment = @commentable.comment_threads.find(params.has_key?(:comment_id) ? params[:comment_id] : params[:id]) 
    end
end
