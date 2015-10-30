import pandas as pd

original = pd.read_csv('./raw.csv')
original["COUNTY"] = ""
original["EMPLOYMENT"] = ""
original["LABOR_PARTICIPATION"] = ""
original["WEIGHT"] = original["PERWT"]
original["INCOME"] = original["INCTOT"]

def filter_row(row):
	state = str(row["STATEFIP"]).zfill(2)
	# county = str(row["COUNTYFIPS"]).zfill(3)
	county = "000"
	row["COUNTY"] = "{}{}".format(state, county)

	employment = row["EMPSTAT"]
	labor_participation = 0
	if employment == 0:
		employment = -1
		labor_participation = -1
	if employment == 1:
		employment = 1
		labor_participation = 1
	elif employment == 2:
		employment = 0
		labor_participation = 1
	elif employment == 3:
		employment = 0
		labor_participation = 0

	row["SEX"] -= 1
	row["EMPLOYMENT"] = employment
	row["LABOR_PARTICIPATION"] = labor_participation
	return row

edited = original.apply(filter_row, axis=1)

desired_columns = ["COUNTY", "EMPLOYMENT", "INCOME", "LABOR_PARTICIPATION", "WEIGHT", "SEX", "AGE"]
edited = edited[desired_columns]

edited.to_csv("./sample.csv", index=False)