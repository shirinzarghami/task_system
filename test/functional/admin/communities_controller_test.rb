require 'test_helper'

class Admin::CommunitiesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @user = create :user, global_role: 'admin'
    @community = create :community

    @user_params = {community: {name: 'Test', subdomain: 'test', max_users: 20}}
    sign_in @user
  end

  test "Should do a get" do
    get :index
    assert_response :success
  end

  test "Should do a new" do
    get :new
    assert_response :success
  end

  test "Should do a edit" do
    get :edit, id: @community.id
    assert_response :success
  end

  test "Should do create" do
    post :create, @user_params
    assert_response :redirect
    assert_redirected_to admin_communities_path
  end

  test "Should do update" do
    put :update, @user_params.merge(id: @community.id)
    assert_response :redirect
    assert_redirected_to admin_communities_path
  end

  test "Should do destroy" do
    delete :destroy, id: @community.id
    refute Community.exists?(@community)
  end

end
