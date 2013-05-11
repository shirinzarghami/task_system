require 'test_helper'

class ScheduleControllerTest < ActionController::TestCase
  test "should get todo" do
    get :todo
    assert_response :success
  end

  test "should get open" do
    get :open
    assert_response :success
  end

  test "should get completed" do
    get :completed
    assert_response :success
  end

end
