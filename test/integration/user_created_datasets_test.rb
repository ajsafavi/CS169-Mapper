require 'test_helper'

class UserCreatedDatasetsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  setup do
    @farm_datafile = fixture_file_upload("#{Rails.root}/test/fixtures/file_fixtures/farm.csv", "text/csv")
    @appliance_datafile = fixture_file_upload("#{Rails.root}/test/fixtures/file_fixtures/appliances.csv", "text/csv")
    @user = users(:aryan)
    login_as @user
  end

  test "basic dataset" do

    login_as @user
    columns = [{name: "ROOMS", column_type: "VARIABLE", null_value: "0"},
        {name: "HHWT", column_type: "WEIGHT"},
        {name: "COUNTY_FULL_FIPS", column_type: "LOCATION", detail_level: "countyfull"}]

    params = { 'name' => 'farm_basic', "owner" => @user.id, "datafile" => @appliance_datafile, "columns" => columns}

    assert_difference('Dataset.count') do
      post "/datasets/", params
    end

    basic_dataset = assigns(:dataset)

    assert_not_nil basic_dataset.filepath, "The filepath should be set after being created"
    
    assert_redirected_to dataset_path(basic_dataset)

    get "/datasets/#{basic_dataset.id}/points", {:display_val => "ROOMS", :detail_level => "STATE", :num_points => 5000}

    assert assigns(:points), "Points should be returned"
    assert assigns(:points).size > 30, "Points should not be empty"

  end


  test "english location names" do
    login_as @user
    columns = [{name: "ROOMS", column_type: "VARIABLE", null_value: "0"},
        {name: "HHWT", column_type: "WEIGHT"},
        {name: "COUNTY_FULL_ENGLISH", column_type: "LOCATION", detail_level: "countyfull"}]

    params = { 'name' => 'farm_basic', "owner" => @user.id, "datafile" => @appliance_datafile, "columns" => columns}

    assert_difference('Dataset.count') do
      post "/datasets/", params
    end

    basic_dataset = assigns(:dataset)

    assert_not_nil basic_dataset.filepath, "The filepath should be set after being created"
    
    assert_redirected_to dataset_path(basic_dataset)

    get "/datasets/#{basic_dataset.id}/points", {:display_val => "ROOMS", :detail_level => "STATE", :num_points => 5000}
    assert assigns(:points), "Points should be returned"
    assert assigns(:points).size > 30, "Points should not be empty"

    get "/datasets/#{basic_dataset.id}/points", {:display_val => "ROOMS", :detail_level => "COUNTY", :num_points => 5000}
    assert assigns(:points), "Points should be returned"
    assert assigns(:points).size > 30, "Points should not be empty"
  end

  test "two english location columns" do
    login_as @user
    columns = [{name: "ROOMS", column_type: "VARIABLE", null_value: "0"},
        {name: "HHWT", column_type: "WEIGHT"},
        {name: "STATE_ENGLISH", column_type: "LOCATION", detail_level: "state"},
        {name: "COUNTY_ENGLISH", column_type: "LOCATION", detail_level: "countypartial"}]

    params = { 'name' => 'farm_basic', "owner" => @user.id, "datafile" => @appliance_datafile, "columns" => columns}

    assert_difference('Dataset.count') do
      post "/datasets/", params
    end

    basic_dataset = assigns(:dataset)

    assert_not_nil basic_dataset.filepath, "The filepath should be set after being created"
    
    assert_redirected_to dataset_path(basic_dataset)

    get "/datasets/#{basic_dataset.id}/points", {:display_val => "ROOMS", :detail_level => "STATE", :num_points => 5000}
    assert assigns(:points), "Points should be returned"
    assert assigns(:points).size > 30, "Points should not be empty"

    get "/datasets/#{basic_dataset.id}/points", {:display_val => "ROOMS", :detail_level => "COUNTY", :num_points => 5000}
    assert assigns(:points), "Points should be returned"
    assert assigns(:points).size > 30, "Points should not be empty"
  end

  test "two fips location columns" do
    login_as @user
    columns = [{name: "ROOMS", column_type: "VARIABLE", null_value: "0"},
        {name: "HHWT", column_type: "WEIGHT"},
        {name: "STATE_FIPS", column_type: "LOCATION", detail_level: "state"},
        {name: "COUNTYFIPS", column_type: "LOCATION", detail_level: "countypartial"}]

    params = { 'name' => 'farm_basic', "owner" => @user.id, "datafile" => @appliance_datafile, "columns" => columns}

    assert_difference('Dataset.count') do
      post "/datasets/", params
    end

    basic_dataset = assigns(:dataset)

    assert_not_nil basic_dataset.filepath, "The filepath should be set after being created"
    
    assert_redirected_to dataset_path(basic_dataset)

    get "/datasets/#{basic_dataset.id}/points", {:display_val => "ROOMS", :detail_level => "STATE", :num_points => 5000}
    assert assigns(:points), "Points should be returned"
    assert assigns(:points).size > 30, "Points should not be empty"

    get "/datasets/#{basic_dataset.id}/points", {:display_val => "ROOMS", :detail_level => "COUNTY", :num_points => 5000}
    assert assigns(:points), "Points should be returned"
    assert assigns(:points).size > 30, "Points should not be empty"
  end

  test "two mixed location columns" do
    login_as @user
    columns = [{name: "ROOMS", column_type: "VARIABLE", null_value: "0"},
        {name: "HHWT", column_type: "WEIGHT"},
        {name: "STATE_ENGLISH", column_type: "LOCATION", detail_level: "state"},
        {name: "COUNTYFIPS", column_type: "LOCATION", detail_level: "countypartial"}]

    params = { 'name' => 'farm_basic', "owner" => @user.id, "datafile" => @appliance_datafile, "columns" => columns}

    assert_difference('Dataset.count') do
      post "/datasets/", params
    end

    basic_dataset = assigns(:dataset)

    assert_not_nil basic_dataset.filepath, "The filepath should be set after being created"
    
    assert_redirected_to dataset_path(basic_dataset)

    get "/datasets/#{basic_dataset.id}/points", {:display_val => "ROOMS", :detail_level => "STATE", :num_points => 5000}
    assert assigns(:points), "Points should be returned"
    assert assigns(:points).size > 30, "Points should not be empty"

    get "/datasets/#{basic_dataset.id}/points", {:display_val => "ROOMS", :detail_level => "COUNTY", :num_points => 5000}
    assert assigns(:points), "Points should be returned"
    assert assigns(:points).size > 30, "Points should not be empty"
  end



end
