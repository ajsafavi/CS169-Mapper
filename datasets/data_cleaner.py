import pandas as pd
import json

with open("./FipsCountyCodes.json") as fp:
	fips_raw = json.load(fp)["table"]["rows"]

fips_to_loc = dict()

for fips, location in fips_raw:
	location = location.split(",")
	entry = dict()
	entry["state_abbrev"] = location[0].strip()
	if len(location) == 2:
		entry["county_partial"] = location[1].strip()
	fips_to_loc[fips] = entry

with open("./states_hash.json") as fp:
	states_hash = json.load(fp)

def abbrev_to_state(abbrev):
	return states_hash[abbrev]

def fips_to_county(fips):
	return fips_to_loc[fips]["county_partial"]

def fips_to_state_abbrev(fips):
	return fips_to_loc[fips]["state_abbrev"]



original = pd.read_csv('./farm_raw.csv')
original["STATE_ENGLISH"] = None
original["STATE_FIPS"] = None
original["STATE_ENGLISH_SHORT"] = None
original["COUNTY_ENGLISH"] = None
original["COUNTY_FULL_FIPS"] = None
original["COUNTY_PARTIAL_FIPS"] = None
original["COUNTY_FULL_ENGLISH"] = None

original["STATE_FIPS_MAPPR"] = None
original["COUNTY_FIPS_MAPPR"] = None
original["valid"] = True

x = {"rows" : 0}

def filter_row(row):
	row["FARM"] -= 1
	# print row["COUNTYFIPS"]
	x["rows"] += 1
	if x["rows"] % 1000 == 0:
		print x["rows"]
	try:
		row["COUNTY_PARTIAL_FIPS"] = str(row["COUNTYFIPS"]).zfill(3)
		row["STATE_FIPS"] = str(row["STATEFIPS"]).zfill(2)
		row["STATE_FIPS_MAPPR"] = row["STATE_FIPS"] + "000"
		row["COUNTY_FULL_FIPS"] = row["STATE_FIPS"] + row["COUNTY_PARTIAL_FIPS"]
		row["COUNTY_FIPS_MAPPR"] = row["COUNTY_FULL_FIPS"]
		row["STATE_ENGLISH_SHORT"] = fips_to_state_abbrev(row["COUNTY_FULL_FIPS"])
		row["STATE_ENGLISH"] = abbrev_to_state(row["STATE_ENGLISH_SHORT"])
		row["COUNTY_ENGLISH"] = fips_to_county(row["COUNTY_FULL_FIPS"])
		row["COUNTY_FULL_ENGLISH"] = "{}, {}".format(row["COUNTY_ENGLISH"], row["STATE_ENGLISH"])
	except(KeyError):
		row["valid"] = False
		pass;

	return row

desired_columns = ["HHWT", "COUNTYFIPS", "FARM", "STATE_FIPS", \
	"STATE_ENGLISH", "COUNTY_ENGLISH", "COUNTY_FULL_ENGLISH", "COUNTY_FULL_FIPS",
	"STATE_FIPS_MAPPR", "COUNTY_FIPS_MAPPR"]

edited = original.apply(filter_row, axis=1)
edited = edited.loc[edited["valid"] == True]
edited = edited[desired_columns]

edited.to_csv("./farm.csv", index=False)
