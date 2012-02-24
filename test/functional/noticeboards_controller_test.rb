require 'test_helper'

class NoticeboardsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:noticeboards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create noticeboard" do
    assert_difference('Noticeboard.count') do
      post :create, :noticeboard => { }
    end

    assert_redirected_to noticeboard_path(assigns(:noticeboard))
  end

  test "should show noticeboard" do
    get :show, :id => noticeboards(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => noticeboards(:one).to_param
    assert_response :success
  end

  test "should update noticeboard" do
    put :update, :id => noticeboards(:one).to_param, :noticeboard => { }
    assert_redirected_to noticeboard_path(assigns(:noticeboard))
  end

  test "should destroy noticeboard" do
    assert_difference('Noticeboard.count', -1) do
      delete :destroy, :id => noticeboards(:one).to_param
    end

    assert_redirected_to noticeboards_path
  end
end
