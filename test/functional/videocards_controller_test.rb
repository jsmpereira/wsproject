require 'test_helper'

class VideocardsControllerTest < ActionController::TestCase
  setup do
    @videocard = videocards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:videocards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create videocard" do
    assert_difference('Videocard.count') do
      post :create, :videocard => @videocard.attributes
    end

    assert_redirected_to videocard_path(assigns(:videocard))
  end

  test "should show videocard" do
    get :show, :id => @videocard.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @videocard.to_param
    assert_response :success
  end

  test "should update videocard" do
    put :update, :id => @videocard.to_param, :videocard => @videocard.attributes
    assert_redirected_to videocard_path(assigns(:videocard))
  end

  test "should destroy videocard" do
    assert_difference('Videocard.count', -1) do
      delete :destroy, :id => @videocard.to_param
    end

    assert_redirected_to videocards_path
  end
end
