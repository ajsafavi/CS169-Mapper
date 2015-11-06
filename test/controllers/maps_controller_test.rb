require 'test_helper'

class MapsControllerTest < ActionController::TestCase
  setup do
    @map = maps(:default_map)
    @user = users(:aryan)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:maps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create map" do
    assert_difference('Map.count') do
      post :create, { }
    end
    
    assert_redirected_to map_path(assigns(:map))
  end

  test "should show map" do
    get :show, id: @map
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @map
    assert_response :success
  end

  test "should update map" do
    patch :update, id: @map, name: "NEWNAME", display_variable: "SEX"
    assert_equal("NEWNAME", assigns(:map).name , "Name of dataset should be updated to NEWNAME")
    assert_equal("SEX", assigns(:map).display_variable , "display_val should be updated")
    assert_redirected_to map_path(assigns(:map))
  end

  test "should destroy map" do
    assert_difference('Map.count', -1) do
      delete :destroy, id: @map
    end

    # assert_redirected_to maps_path
  end

  test "should return points" do
    dataset = @map.dataset
    get :points, {:id => @map, :display_val => "INCOME", :num_points => 5000}

    assert assigns(:points), "Points should be returned"
    assert assigns(:points).size > 0, "Points should not be empty"
  end

end
