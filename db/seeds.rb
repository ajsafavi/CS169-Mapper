# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

aryan = User.create({email: 'persian_princess242@yahoo.com', password: "password123", password_confirmation: "password123"})

filepath = Rails.root.join('datasets','sample.csv').to_s
name = "Sample Dataset"
dataset = Dataset.create({
	name: name,
	filepath: filepath, 
	user_id: nil,
	is_public: true
})

dataset.columns.create({name: "COUNTY_FIPS_MAPPR", column_type: "LOCATION", detail_level: "countyfull"})
dataset.columns.create({name: "STATE_FIPS_MAPPR", column_type: "LOCATION", detail_level: "state"})
dataset.columns.create({name: "WEIGHT", column_type: "WEIGHT", null_value: nil})
dataset.columns.create({name: "EMPLOYMENT", column_type: "VARIABLE", null_value: "-1"})
dataset.columns.create({name: "LABOR_PARTICIPATION", column_type: "VARIABLE", null_value: "-1"})
dataset.columns.create({name: "INCOME", column_type: "VARIABLE", null_value: "9999999"})
dataset.columns.create({name: "SEX", column_type: "VARIABLE", null_value: nil})
dataset.columns.create({name: "AGE", column_type: "VARIABLE", null_value: nil})

filepath = Rails.root.join('datasets','farm.csv').to_s
name = "Farm Dataset"
dataset = Dataset.create({
	name: name,
	filepath: filepath, 
	user_id: aryan.id,
	is_public: true
	})
dataset.columns.create({name: "COUNTY_FIPS_MAPPR", column_type: "LOCATION", detail_level: "countyfull"})
dataset.columns.create({name: "STATE_FIPS_MAPPR", column_type: "LOCATION", detail_level: "state"})
dataset.columns.create({name: "WEIGHT", column_type: "WEIGHT", null_value: nil})
dataset.columns.create({name: "FARM", column_type: "VARIABLE", null_value: "-1"})



map = Map.create({
	name: "test_map",
	user_id: aryan.id,
	dataset_id: dataset.id,
	shareable_url: "test_map_0001",
	styling: "",
	is_example: true
	})