require 'test_helper'

class DatasetsControllerTest < ActionController::TestCase
  setup do
    @dataset = datasets(:sample)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:datasets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dataset" do
    assert_difference('Dataset.count') do
      post :create, {  }
    end

    assert_redirected_to dataset_path(assigns(:dataset))
  end

  test "should show dataset" do
    get :show, id: @dataset
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dataset
    assert_response :success
  end

  test "should update dataset" do
    patch :update, id: @dataset, name: 'NEWNAME'
    assert assigns(:dataset), "dataset not created"
    assert_equal("NEWNAME", assigns(:dataset).name , "Name of dataset should be updated to NEWNAME")
    assert_redirected_to dataset_path(assigns(:dataset))
    
  end

  test "should destroy dataset" do
    assert_difference('Dataset.count', -1) do
      delete :destroy, id: @dataset
    end

    # assert_redirected_to datasets_path
  end

  # Other Custom Methods

end
