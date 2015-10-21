# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

aryan = User.create({first_name: 'aryan', last_name: 'flappy', email: 'persian_princess242@yahoo.com'})

filepath = Rails.root.join('datasets','sample.csv').to_s
num_rows = 114487
location_column = "COUNTY"
weight_column = "WEIGHT"
location_type = "COUNTYFIPS"
name = "DEFAULT DATASET"

dataset = Dataset.create({
	name: name,
	filepath: filepath, 
	num_rows: num_rows, 
	location_column: location_column, 
	weight_column: weight_column, 
	location_type: location_type,
	user_id: aryan.id
	})

dataset.columns.create({name: "COUNTY", column_type: "LOCATION", null_value: nil})
dataset.columns.create({name: "WEIGHT", column_type: "WEIGHT", null_value: nil})
dataset.columns.create({name: "EMPLOYMENT", column_type: "VARIABLE", null_value: "-1"})
dataset.columns.create({name: "LABOR_PARTICIPATION", column_type: "VARIABLE", null_value: "-1"})
dataset.columns.create({name: "INCOME", column_type: "VARIABLE", null_value: "9999999"})
dataset.columns.create({name: "SEX", column_type: "VARIABLE", null_value: nil})
dataset.columns.create({name: "AGE", column_type: "VARIABLE", null_value: nil})


map = Map.create({
	name: "test_map",
	user_id: aryan.id,
	dataset_id: dataset.id,
	shareable_url: "test_map_0001",
	styling: ""
	})