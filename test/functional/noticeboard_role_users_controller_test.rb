require 'test_helper'

class NoticeboardRoleUsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:noticeboard_role_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create noticeboard_role_user" do
    assert_difference('NoticeboardRoleUser.count') do
      post :create, :noticeboard_role_user => { }
    end

    assert_redirected_to noticeboard_role_user_path(assigns(:noticeboard_role_user))
  end

  test "should show noticeboard_role_user" do
    get :show, :id => noticeboard_role_users(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => noticeboard_role_users(:one).to_param
    assert_response :success
  end

  test "should update noticeboard_role_user" do
    put :update, :id => noticeboard_role_users(:one).to_param, :noticeboard_role_user => { }
    assert_redirected_to noticeboard_role_user_path(assigns(:noticeboard_role_user))
  end

  test "should destroy noticeboard_role_user" do
    assert_difference('NoticeboardRoleUser.count', -1) do
      delete :destroy, :id => noticeboard_role_users(:one).to_param
    end

    assert_redirected_to noticeboard_role_users_path
  end
end
