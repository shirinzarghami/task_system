class TagsController < ApplicationController
  before_filter :find_community, :find_taggable

  def index
    @tags = ActsAsTaggableOn::Tagging.joins(:tag).where("name LIKE '%#{params[:q]}%'").where(taggable_type: @taggable_type, tagger_type: 'Community', tagger_id: @community.id).select('name as name, tags.id as id')
    respond_to do |format|
      format.json {render json: @tags.to_json}
    end
  end

  private
    def find_taggable
      @taggable_type = request.path.split('/')[-2].classify
    end
end
