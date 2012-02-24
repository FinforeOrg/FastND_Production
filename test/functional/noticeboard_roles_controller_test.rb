require 'test_helper'

class NoticeboardRolesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:noticeboard_roles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create noticeboard_role" do
    assert_difference('NoticeboardRole.count') do
      post :create, :noticeboard_role => { }
    end

    assert_redirected_to noticeboard_role_path(assigns(:noticeboard_role))
  end

  test "should show noticeboard_role" do
    get :show, :id => noticeboard_roles(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => noticeboard_roles(:one).to_param
    assert_response :success
  end

  test "should update noticeboard_role" do
    put :update, :id => noticeboard_roles(:one).to_param, :noticeboard_role => { }
    assert_redirected_to noticeboard_role_path(assigns(:noticeboard_role))
  end

  test "should destroy noticeboard_role" do
    assert_difference('NoticeboardRole.count', -1) do
      delete :destroy, :id => noticeboard_roles(:one).to_param
    end

    assert_redirected_to noticeboard_roles_path
  end
end
