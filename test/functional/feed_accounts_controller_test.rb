require '../test_helper'

class FeedAccountsControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def destroy_ with_options
    get :destroy, 860, :REQUEST_METHOD => 'OPTIONS'
    assert_response :success
  end
  
end
