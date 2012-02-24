require 'test_helper'

class UserCompanyTabsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_company_tabs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_company_tab" do
    assert_difference('UserCompanyTab.count') do
      post :create, :user_company_tab => { }
    end

    assert_redirected_to user_company_tab_path(assigns(:user_company_tab))
  end

  test "should show user_company_tab" do
    get :show, :id => user_company_tabs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => user_company_tabs(:one).to_param
    assert_response :success
  end

  test "should update user_company_tab" do
    put :update, :id => user_company_tabs(:one).to_param, :user_company_tab => { }
    assert_redirected_to user_company_tab_path(assigns(:user_company_tab))
  end

  test "should destroy user_company_tab" do
    assert_difference('UserCompanyTab.count', -1) do
      delete :destroy, :id => user_company_tabs(:one).to_param
    end

    assert_redirected_to user_company_tabs_path
  end
end
