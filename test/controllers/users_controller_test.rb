require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:aryan)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, {:first_name => "bob", :last_name => "smith", :email => "bob@smith.com"}
    end
    assert assigns(:user)
    assert_equal("bob", assigns(:user).first_name , "First Name of user should be bob")
    assert_equal("smith", assigns(:user).last_name , "Last Name of user should be smith")
    assert_redirected_to user_path(assigns(:user))
  end

  test "should show user" do
    get :show, id: @user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user
    assert_response :success
  end

  test "should update user" do
    patch :update, id: @user, first_name: "NEWNAME"
    assert_equal("NEWNAME", assigns(:user).first_name , "Name of user should be updated to NEWNAME")
    assert_redirected_to user_path(assigns(:user))
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end

    # assert_redirected_to users_path
  end
end
