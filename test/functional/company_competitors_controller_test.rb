require 'test_helper'

class CompanyCompetitorsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:company_competitors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create company_competitor" do
    assert_difference('CompanyCompetitor.count') do
      post :create, :company_competitor => { }
    end

    assert_redirected_to company_competitor_path(assigns(:company_competitor))
  end

  test "should show company_competitor" do
    get :show, :id => company_competitors(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => company_competitors(:one).to_param
    assert_response :success
  end

  test "should update company_competitor" do
    put :update, :id => company_competitors(:one).to_param, :company_competitor => { }
    assert_redirected_to company_competitor_path(assigns(:company_competitor))
  end

  test "should destroy company_competitor" do
    assert_difference('CompanyCompetitor.count', -1) do
      delete :destroy, :id => company_competitors(:one).to_param
    end

    assert_redirected_to company_competitors_path
  end
end
