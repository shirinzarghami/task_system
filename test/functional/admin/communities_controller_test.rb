require 'test_helper'

class Admin::CommunitiesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  include Devise::TestHelpers

  def setup
    @user = users(:one)
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
    get :edit, id: @user
    assert_response :success
  end

  test "Should do create" do
    post :create, @user_params
    assert_response :redirect
    assert_redirected_to admin_communities_path
  end

  test "Should do update" do
    put :update, @user_params.merge(id: @user)
    assert_response :redirect
    assert_redirected_to admin_communities_path
  end

  test "Should do destroy" do
    delete :destroy, id: @user 
  end

end
