require 'test_helper'

class CommunitiesControllerTest < ActionController::TestCase

  context "not logged on" do
    should "redirect when visiting index" do
      get :index
      assert_redirected_to new_user_session_path
    end    

    should "render when visiting show" do
      @community = FactoryGirl.create :community
      get :show, id: @community.subdomain
      assert_redirected_to new_user_session_path
    end

    should "render when visiting new" do
      get :new
      assert_redirected_to new_user_session_path
    end
  end

  context "logged on as user that is NOT a member" do
    setup do
      @user = FactoryGirl.create :user
      @community = FactoryGirl.create :community
      sign_in @user
    end

    should "render when visiting index" do
      get :index
      assert_response :success
    end

    should "render when visiting show" do
      @community = FactoryGirl.create :community
      get :show, id: @community.subdomain
      assert_response :not_found
    end

    should "render when visiting new" do
      get :new
      assert_response :success
    end
  end

  context "logged on as user that is a member" do
    setup do
      @community = FactoryGirl.create :community_with_users
      @user = @community.members.first
      sign_in @user
    end

    should "render when visiting show" do
      get :show, id: @community.subdomain
      assert_response :success
    end

  end

end
