require 'test_helper'

class ResidentialRealtiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:residential_realties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create residential_realty" do
    assert_difference('ResidentialRealty.count') do
      post :create, :residential_realty => { }
    end

    assert_redirected_to residential_realty_path(assigns(:residential_realty))
  end

  test "should show residential_realty" do
    get :show, :id => residential_realties(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => residential_realties(:one).to_param
    assert_response :success
  end

  test "should update residential_realty" do
    put :update, :id => residential_realties(:one).to_param, :residential_realty => { }
    assert_redirected_to residential_realty_path(assigns(:residential_realty))
  end

  test "should destroy residential_realty" do
    assert_difference('ResidentialRealty.count', -1) do
      delete :destroy, :id => residential_realties(:one).to_param
    end

    assert_redirected_to residential_realties_path
  end
end
