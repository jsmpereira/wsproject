require 'test_helper'

class MotherboardsControllerTest < ActionController::TestCase
  setup do
    @motherboard = motherboards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:motherboards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create motherboard" do
    assert_difference('Motherboard.count') do
      post :create, :motherboard => @motherboard.attributes
    end

    assert_redirected_to motherboard_path(assigns(:motherboard))
  end

  test "should show motherboard" do
    get :show, :id => @motherboard.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @motherboard.to_param
    assert_response :success
  end

  test "should update motherboard" do
    put :update, :id => @motherboard.to_param, :motherboard => @motherboard.attributes
    assert_redirected_to motherboard_path(assigns(:motherboard))
  end

  test "should destroy motherboard" do
    assert_difference('Motherboard.count', -1) do
      delete :destroy, :id => @motherboard.to_param
    end

    assert_redirected_to motherboards_path
  end
end
