require 'test_helper'

class FeedApisControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feed_apis)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feed_apis" do
    assert_difference('FeedApis.count') do
      post :create, :feed_apis => { }
    end

    assert_redirected_to feed_apis_path(assigns(:feed_apis))
  end

  test "should show feed_apis" do
    get :show, :id => feed_apis(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => feed_apis(:one).to_param
    assert_response :success
  end

  test "should update feed_apis" do
    put :update, :id => feed_apis(:one).to_param, :feed_apis => { }
    assert_redirected_to feed_apis_path(assigns(:feed_apis))
  end

  test "should destroy feed_apis" do
    assert_difference('FeedApis.count', -1) do
      delete :destroy, :id => feed_apis(:one).to_param
    end

    assert_redirected_to feed_apis_path
  end
end
