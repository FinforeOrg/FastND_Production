require 'test_helper'

class NoticeboardCommentsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:noticeboard_comments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create noticeboard_comment" do
    assert_difference('NoticeboardComment.count') do
      post :create, :noticeboard_comment => { }
    end

    assert_redirected_to noticeboard_comment_path(assigns(:noticeboard_comment))
  end

  test "should show noticeboard_comment" do
    get :show, :id => noticeboard_comments(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => noticeboard_comments(:one).to_param
    assert_response :success
  end

  test "should update noticeboard_comment" do
    put :update, :id => noticeboard_comments(:one).to_param, :noticeboard_comment => { }
    assert_redirected_to noticeboard_comment_path(assigns(:noticeboard_comment))
  end

  test "should destroy noticeboard_comment" do
    assert_difference('NoticeboardComment.count', -1) do
      delete :destroy, :id => noticeboard_comments(:one).to_param
    end

    assert_redirected_to noticeboard_comments_path
  end
end
