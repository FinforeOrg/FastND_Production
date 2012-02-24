require 'test_helper'

class PriceTickersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:price_tickers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create price_ticker" do
    assert_difference('PriceTicker.count') do
      post :create, :price_ticker => { }
    end

    assert_redirected_to price_ticker_path(assigns(:price_ticker))
  end

  test "should show price_ticker" do
    get :show, :id => price_tickers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => price_tickers(:one).to_param
    assert_response :success
  end

  test "should update price_ticker" do
    put :update, :id => price_tickers(:one).to_param, :price_ticker => { }
    assert_redirected_to price_ticker_path(assigns(:price_ticker))
  end

  test "should destroy price_ticker" do
    assert_difference('PriceTicker.count', -1) do
      delete :destroy, :id => price_tickers(:one).to_param
    end

    assert_redirected_to price_tickers_path
  end
end
