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
      # assert_error_flash
    end    

    should "not be allowed to destroy" do
      delete :destroy, community_id: @community.subdomain, task_occurrence_id: @task_occurrence.id, id: @comment.id
      assert_redirected_to new_user_session_path
      # assert_error_flash
    end

  end

  context "logged in as user" do
    setup do 
      @community = FactoryGirl.create :community_with_users, users_count: 1
      @admin_user = @community.admin_users.first
      @normal_user1 = FactoryGirl.create(:user) and @community.users << @normal_user1
      @normal_user2 = FactoryGirl.create(:user) and @community.users << @normal_user2


      @comment = FactoryGirl.create :comment_with_task_occurrence, user: @normal_user1
      @task_occurrence = @comment.commentable
      sign_in @normal_user1
    end

    should "be allowed to create" do
      post :create, community_id: @community.subdomain, task_occurrence_id: @task_occurrence.id, comment_body: 'Test test testikel'
      assert_redirected_to community_task_occurrence_path(@community, @task_occurrence)
      assert_notice_flash
    end

    context "normal user" do
      should "be allowed to destroy when the user created that comment" do
        delete :destroy, community_id: @community.subdomain, task_occurrence_id: @task_occurrence.id, id: @comment.id
        assert_redirected_to community_task_occurrence_path(@community, @task_occurrence)
        assert_notice_flash
      end

      should "NOT be allowed to destroy when the user did not create the comment" do
        sign_in @normal_user2
        delete :destroy, community_id: @community.subdomain, task_occurrence_id: @task_occurrence.id, id: @comment.id
        assert_redirected_to communities_path
        assert_error_flash
      end
    end

    context "admin user" do
      setup do
        sign_in @admin_user
      end

      should "be allowed to destroy when the user did not create the comment" do
        sign_in @admin_user
        delete :destroy, community_id: @community.subdomain, task_occurrence_id: @task_occurrence.id, id: @comment.id
        assert_redirected_to community_task_occurrence_path(@community, @task_occurrence)
        assert_notice_flash
      end
    end

    context "user not in the community" do
      setup do
        @no_community_user = FactoryGirl.create(:user)
        sign_in @no_community_user
      end

      should "NOT be allowed to destroy" do
        delete :destroy, community_id: @community.subdomain, task_occurrence_id: @task_occurrence.id, id: @comment.id
        assert_response :not_found
      end

      should "not be allowed to create" do
        post :create, community_id: @community.subdomain, task_occurrence_id: @task_occurrence.id, comment_body: 'Test test testikel'
        assert_response :not_found
      end
    end
  end


end
