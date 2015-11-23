import json

full_to_fips = dict()
fips_to_full = dict()

with open("./FipsCountyCodes.json") as fp:
	county_codes = json.load(fp)

with open("./states_hash.json") as fp:
	state_hash = json.load(fp)

for (fips, key) in county_codes["table"]["rows"]:
	key_split = key.split(",")
	state = key_split[0].upper().strip()

	if state not in state_hash:
		print state
		continue

	state = state_hash[state].upper()
	key = state
	if len(key_split) == 2:
		county = key_split[1].upper().strip()
		key = "{}, {}".format(county, state)
	full_to_fips[key] = fips
	fips_to_full[fips] = key

with open("full_to_fips.json", "w") as fp:
	json.dump(full_to_fips, fp, indent=4)

with open("fips_to_full.json", "w") as fp:
	json.dump(fips_to_full, fp, indent=4)