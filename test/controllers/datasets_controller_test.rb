require 'test_helper'

class DatasetsControllerTest < ActionController::TestCase

  setup do
    @dataset = datasets(:sample)
    @user = users(:aryan)
    sign_in @user
    @sample_datafile = fixture_file_upload("file_fixtures/sample.csv", "text/csv")
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ans)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dataset" do

    columns = [{name: "EMPLOYMENT", column_type: "VARIABLE", null_value: "9999999"},
        {name: "SEX", column_type: "VARIABLE", null_value: "-1"},
        {name: "WEIGHT", column_type: "WEIGHT", null_value: "-1"},
        {name: "COUNTY", column_type: "LOCATION", detail_level: "countyfull", null_value: "-1"}]

    params = { 'name' => 'new', 'owner' => @user.id, "datafile" => @sample_datafile, "columns" => columns}
    assert_difference('Dataset.count') do
      post :create, params
    end

    new_dataset = assigns(:dataset)
    assert_not_nil new_dataset.filepath, "The filepath should be set after being created"
    
    assert_redirected_to dataset_path(new_dataset)

    get :points, {:id => new_dataset, :display_val => "EMPLOYMENT", :detail_level => "STATE", :num_points => 5000}

    assert assigns(:points), "Points should be returned"
    assert assigns(:points).size > 0, "Points should not be empty"
  end

  test "should show dataset" do
    get :show, id: @dataset
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dataset
    assert_response :success
  end

  # test "should update dataset" do
  #   patch :update, id: @dataset, name: 'NEWNAME'
  #   assert assigns(:dataset), "dataset not created"
  #   assert_equal("NEWNAME", assigns(:dataset).name , "Name of dataset should be updated to NEWNAME")
  #   assert_redirected_to dataset_path(assigns(:dataset))
    
  # end

  test "should destroy dataset" do
    assert_difference('Dataset.count', -1) do
      delete :destroy, id: @dataset
    end

    # assert_redirected_to datasets_path
  end


  test "should return points" do
    get :points, {:id => @dataset, :display_val => "INCOME", :num_points => 5000}

    assert assigns(:points), "Points should be returned"
    assert assigns(:points).size > 0, "Points should not be empty"
  end

  # Other Custom Methods

end
