require 'test_helper'

class NoticeboardPostsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:noticeboard_posts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create noticeboard_post" do
    assert_difference('NoticeboardPost.count') do
      post :create, :noticeboard_post => { }
    end

    assert_redirected_to noticeboard_post_path(assigns(:noticeboard_post))
  end

  test "should show noticeboard_post" do
    get :show, :id => noticeboard_posts(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => noticeboard_posts(:one).to_param
    assert_response :success
  end

  test "should update noticeboard_post" do
    put :update, :id => noticeboard_posts(:one).to_param, :noticeboard_post => { }
    assert_redirected_to noticeboard_post_path(assigns(:noticeboard_post))
  end

  test "should destroy noticeboard_post" do
    assert_difference('NoticeboardPost.count', -1) do
      delete :destroy, :id => noticeboard_posts(:one).to_param
    end

    assert_redirected_to noticeboard_posts_path
  end
end
