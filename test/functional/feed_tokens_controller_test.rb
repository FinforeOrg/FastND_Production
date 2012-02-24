require 'test_helper'

class FeedTokensControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:feed_tokens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create feed_tokens" do
    assert_difference('FeedTokens.count') do
      post :create, :feed_tokens => { }
    end

    assert_redirected_to feed_tokens_path(assigns(:feed_tokens))
  end

  test "should show feed_tokens" do
    get :show, :id => feed_tokens(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => feed_tokens(:one).to_param
    assert_response :success
  end

  test "should update feed_tokens" do
    put :update, :id => feed_tokens(:one).to_param, :feed_tokens => { }
    assert_redirected_to feed_tokens_path(assigns(:feed_tokens))
  end

  test "should destroy feed_tokens" do
    assert_difference('FeedTokens.count', -1) do
      delete :destroy, :id => feed_tokens(:one).to_param
    end

    assert_redirected_to feed_tokens_path
  end
end
