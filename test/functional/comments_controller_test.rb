require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  context "Not logged in" do
    setup do 
      @community = FactoryGirl.create :community_with_users
      @comment = FactoryGirl.create :comment_with_task_occurrence
      @task_occurrence = @comment.commentable
    end

    should "not be allowed to create" do
      post :create, community_id: @community.subdomain, task_occurrence_id: @task_occurrence.id
      assert_redirected_to new_user_session_path
    end    

    should "not be allowed to destroy" do
      delete :destroy, community_id: @community.subdomain, task_occurrence_id: @task_occurrence.id, id: @comment.id
      assert_redirected_to new_user_session_path
    end

  end

  context "logged in as user" do
    setup do 
      @community = FactoryGirl.create :community_with_users
      @user = @community.members.first 
      @comment = FactoryGirl.create :comment_with_task_occurrence, user: @user
      @task_occurrence = @comment.commentable
      sign_in @user
    end

    should "be allowed to create" do
      post :create, {community_id: @community.subdomain, task_occurrence_id: @task_occurrence.id}.merge(FactoryGirl.attributes_for(:comment))
      assert_redirected_to community_task_occurrence_path(@community, @task_occurrence)
    end

    context "normal user" do
      setup do
        @community_user = @user.community_users.first
        
      end
      should "be allowed to destroy when the user created that comment" do
        delete :destroy, community_id: @community.subdomain, task_occurrence_id: @task_occurrence.id, id: @comment.id
        assert_redirected_to community_task_occurrence_path(@community, @task_occurrence)
      end

      should "NOT be allowed to destroy when the user did not create the comment" do
        sign_in @community.members.last #Sign in as annother user
        delete :destroy, community_id: @community.subdomain, task_occurrence_id: @task_occurrence.id, id: @comment.id
        assert_redirected_to community_task_occurrence_path(@community, @task_occurrence)
      end
    end

    context "admin user" do

    end
  end


end
