require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  setup do
    @status = statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statuses)
  end

  test "should be redirected when not logged in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should render the new page when logged in" do
    sign_in users(:isaac)
    get :new
    assert_response :success
  end

  test "should be logged in to post a status" do
    post :create, status: { content: "Hello!" }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should create status when logged in" do
    sign_in users(:isaac)
    
    assert_difference('Status.count') do
      post :create, status: { content: @status.content }
    end

    assert_redirected_to status_path(assigns(:status))
  end

  test "should create an activity item for the status when logged in" do
    sign_in users(:isaac)
    
    assert_difference('Activity.count') do
      post :create, status: { content: @status.content }
    end
  end

  test "should show status" do
    get :show, id: @status
    assert_response :success
  end

  test "should be logged in to edit a status" do
    get :edit, id: @status
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit when logged in" do
    sign_in users(:isaac)
    get :edit, id: @status
    assert_response :success
  end

  test "should redirect status update when not logged in" do
    put :update, id: @status, status: { content: @status.content }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should update status when logged in" do
    sign_in users(:isaac)
    put :update, id: @status, status: { content: @status.content }
    assert_redirected_to status_path(assigns(:status))
  end

  test "should create an activity item when the status is updated" do
    sign_in users(:isaac)
    assert_difference 'Activity.count' do
      put :update, id: @status, status: { content: @status.content }
    end
  end

  test "should destroy status" do
    assert_difference('Status.count', -1) do
      sign_in users(:isaac)
      delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end

  # test "that a status cannot have more than 455 characters" do
  #   sign_in users(:isaac)
  #   post :create, status: { length: 500 }
  #   assert_response :error
  # end
end

