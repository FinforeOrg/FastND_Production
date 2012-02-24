require 'test_helper'

class ProfileCategoriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:profile_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create profile_category" do
    assert_difference('ProfileCategory.count') do
      post :create, :profile_category => { }
    end

    assert_redirected_to profile_category_path(assigns(:profile_category))
  end

  test "should show profile_category" do
    get :show, :id => profile_categories(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => profile_categories(:one).to_param
    assert_response :success
  end

  test "should update profile_category" do
    put :update, :id => profile_categories(:one).to_param, :profile_category => { }
    assert_redirected_to profile_category_path(assigns(:profile_category))
  end

  test "should destroy profile_category" do
    assert_difference('ProfileCategory.count', -1) do
      delete :destroy, :id => profile_categories(:one).to_param
    end

    assert_redirected_to profile_categories_path
  end
end
