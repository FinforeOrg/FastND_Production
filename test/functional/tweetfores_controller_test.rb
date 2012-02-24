require 'test_helper'

class TweetforesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tweetfores)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tweetfore" do
    assert_difference('Tweetfore.count') do
      post :create, :tweetfore => { }
    end

    assert_redirected_to tweetfore_path(assigns(:tweetfore))
  end

  test "should show tweetfore" do
    get :show, :id => tweetfores(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => tweetfores(:one).to_param
    assert_response :success
  end

  test "should update tweetfore" do
    put :update, :id => tweetfores(:one).to_param, :tweetfore => { }
    assert_redirected_to tweetfore_path(assigns(:tweetfore))
  end

  test "should destroy tweetfore" do
    assert_difference('Tweetfore.count', -1) do
      delete :destroy, :id => tweetfores(:one).to_param
    end

    assert_redirected_to tweetfores_path
  end
end
