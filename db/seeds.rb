# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

aryan = User.create({first_name: 'aryan', last_name: 'flappy', email: 'persian_princess242@yahoo.com'})

filepath = Rails.root.join('datasets','sample.csv').to_s
col_names = ["HHWT","STATEICP","STATEFIP","COUNTY","COUNTYFIPS","ACREPROP","RENT","COSTFUEL","HHINCOME","PERNUM","PERWT","SEX","AGE","SCHOOL","EMPSTAT","EMPSTATD","INCTOT","INCWELFR"]
num_rows = 114487
location_column = "COUNTYFIPS"
weight_column = "PERWT"
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

col_names.each do |col_name|
	dataset.columns.create({name: col_name})
end

map = Map.create({
	name: "test_map",
	user_id: aryan.id,
	dataset_id: dataset.id,
	shareable_url: "test_map_0001",
	styling: ""
	})