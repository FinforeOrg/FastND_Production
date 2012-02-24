require 'test_helper'

class PopulateFeedInfosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:populate_feed_infos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create populate_feed_info" do
    assert_difference('PopulateFeedInfo.count') do
      post :create, :populate_feed_info => { }
    end

    assert_redirected_to populate_feed_info_path(assigns(:populate_feed_info))
  end

  test "should show populate_feed_info" do
    get :show, :id => populate_feed_infos(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => populate_feed_infos(:one).to_param
    assert_response :success
  end

  test "should update populate_feed_info" do
    put :update, :id => populate_feed_infos(:one).to_param, :populate_feed_info => { }
    assert_redirected_to populate_feed_info_path(assigns(:populate_feed_info))
  end

  test "should destroy populate_feed_info" do
    assert_difference('PopulateFeedInfo.count', -1) do
      delete :destroy, :id => populate_feed_infos(:one).to_param
    end

    assert_redirected_to populate_feed_infos_path
  end
end
