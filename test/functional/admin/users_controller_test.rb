require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  def setup 
    @user = users(:one)
    @user_params = {user: {email: 'jan@example.com', name: 'Jan', password: 'test1234', password_confirmation: 'test1234'}}
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get create" do
    post :create, @user_params
    assert_response :redirect
    assert_redirected_to admin_users_path
  end

  test "should get edit" do
    get :edit, id: @user.id
    assert_response :success
  end

  test "should get update" do
    put :update, @user_params.merge(id: @user) 
    assert_response :redirect
    assert_redirected_to admin_users_path
  end

  test "should get destroy" do
    delete :destroy, id: @user
    assert_response :redirect
    assert_redirected_to admin_users_path
  end

end
