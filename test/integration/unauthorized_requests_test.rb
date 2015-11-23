require 'test_helper'

class UnauthorizedRequestsTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

	setup do
		@dataset = datasets(:sample)
		@user = users(:aryan)
		@auth_error = 401
	end

	test 'should_require_user_to_create_dataset' do
		post '/datasets/', { 'name' => 'new', 'owner' => @user.id }
		assert_response @auth_error
	end

	test 'authorized_user_must_own_created_dataset' do
		login_as @user
		post '/datasets/', { 'name' => 'new', 'owner' => 20000 }
		assert_response @auth_error
		logout @user
	end

	test 'should_require_user_to_edit_private_dataset' do
		private_map = maps(:default_map)
		map_id = private_map.id
		put '/maps/' + map_id.to_s, {'name' => 'new'}
		assert_response @auth_error
	end

	test 'should_allow_anyone_to_edit_public_map' do
		public_map = maps(:example_map)
		map_id = public_map.id
		put '/maps/' + map_id.to_s, {'name' => 'new'}
		assert_response :redirect
	end

	# test 'should_not_allow_points_from_private_map' do
	# 	private_map = maps(:default_map)
	# 	map_id = private_map.id
	# 	get '/maps/' + map_id.to_s + "/points", {}
	# 	assert_response @auth_error
	# end

	# test 'should_not_allow_points_from_private_dataset' do
	# 	private_dataset = datasets(:private)
	# 	map_id = private_dataset.id
	# 	get '/datasets/' + map_id.to_s + "/points", {}
	# 	assert_response @auth_error
	# end

end
