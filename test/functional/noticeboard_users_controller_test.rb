require 'test_helper'

class NoticeboardUsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:noticeboard_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create noticeboard_user" do
    assert_difference('NoticeboardUser.count') do
      post :create, :noticeboard_user => { }
    end

    assert_redirected_to noticeboard_user_path(assigns(:noticeboard_user))
  end

  test "should show noticeboard_user" do
    get :show, :id => noticeboard_users(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => noticeboard_users(:one).to_param
    assert_response :success
  end

  test "should update noticeboard_user" do
    put :update, :id => noticeboard_users(:one).to_param, :noticeboard_user => { }
    assert_redirected_to noticeboard_user_path(assigns(:noticeboard_user))
  end

  test "should destroy noticeboard_user" do
    assert_difference('NoticeboardUser.count', -1) do
      delete :destroy, :id => noticeboard_users(:one).to_param
    end

    assert_redirected_to noticeboard_users_path
  end
end
