require 'test_helper'

class UserInputDataControllerTest < ActionController::TestCase
  setup do
    @user_input_datum = user_input_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_input_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_input_datum" do
    assert_difference('UserInputDatum.count') do
      post :create, user_input_datum: {  }
    end

    assert_redirected_to user_input_datum_path(assigns(:user_input_datum))
  end

  test "should show user_input_datum" do
    get :show, id: @user_input_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_input_datum
    assert_response :success
  end

  test "should update user_input_datum" do
    patch :update, id: @user_input_datum, user_input_datum: {  }
    assert_redirected_to user_input_datum_path(assigns(:user_input_datum))
  end

  test "should destroy user_input_datum" do
    assert_difference('UserInputDatum.count', -1) do
      delete :destroy, id: @user_input_datum
    end

    assert_redirected_to user_input_data_path
  end
end
