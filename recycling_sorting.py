# This script creates a final data file for a small project on recycling in NC

# Importing required modules

import pandas as pd

# Working directory info

username = ''
direc = 'C:/Users/' + username + '/Documents/Data/recycle_nc/'
acs_dir = 'C:/Users/' + username + '/Documents/Data/ACS/'

# Reading in all of the raw data files

dp02_16 = pd.read_csv(acs_dir + 'DP02_5yr_social/ACSDP5Y2016.DP02_data_with_overlays_2022-05-06T034213.csv')
dp02_17 = pd.read_csv(acs_dir + 'DP02_5yr_social/ACSDP5Y2017.DP02_data_with_overlays_2022-05-06T034213.csv')
dp02_18 = pd.read_csv(acs_dir + 'DP02_5yr_social/ACSDP5Y2018.DP02_data_with_overlays_2022-05-06T034213.csv')
dp02_19 = pd.read_csv(acs_dir + 'DP02_5yr_social/ACSDP5Y2019.DP02_data_with_overlays_2022-05-06T034213.csv')
dp02_20 = pd.read_csv(acs_dir + 'DP02_5yr_social/ACSDP5Y2020.DP02_data_with_overlays_2022-05-06T034213.csv')

dp03_16 = pd.read_csv(acs_dir + 'DP03_5yr_economic/ACSDP5Y2016.DP03_data_with_overlays_2022-05-06T034247.csv')
dp03_17 = pd.read_csv(acs_dir + 'DP03_5yr_economic/ACSDP5Y2017.DP03_data_with_overlays_2022-05-06T034247.csv')
dp03_18 = pd.read_csv(acs_dir + 'DP03_5yr_economic/ACSDP5Y2018.DP03_data_with_overlays_2022-05-06T034247.csv')
dp03_19 = pd.read_csv(acs_dir + 'DP03_5yr_economic/ACSDP5Y2019.DP03_data_with_overlays_2022-05-06T034247.csv')
dp03_20 = pd.read_csv(acs_dir + 'DP03_5yr_economic/ACSDP5Y2020.DP03_data_with_overlays_2022-05-06T034247.csv')

dp04_16 = pd.read_csv(acs_dir + 'DP04_5yr_housing/ACSDP5Y2016.DP04_data_with_overlays_2022-05-08T193758.csv')
dp04_17 = pd.read_csv(acs_dir + 'DP04_5yr_housing/ACSDP5Y2017.DP04_data_with_overlays_2022-05-08T193758.csv')
dp04_18 = pd.read_csv(acs_dir + 'DP04_5yr_housing/ACSDP5Y2018.DP04_data_with_overlays_2022-05-08T193758.csv')
dp04_19 = pd.read_csv(acs_dir + 'DP04_5yr_housing/ACSDP5Y2019.DP04_data_with_overlays_2022-05-08T193758.csv')
dp04_20 = pd.read_csv(acs_dir + 'DP04_5yr_housing/ACSDP5Y2020.DP04_data_with_overlays_2022-05-08T193758.csv')

dp02_16 = pd.concat([dp02_16, pd.Series([2016]*len(dp02_16), name = 'yr')], axis = 1)
dp02_17 = pd.concat([dp02_17, pd.Series([2017]*len(dp02_17), name = 'yr')], axis = 1)
dp02_18 = pd.concat([dp02_18, pd.Series([2018]*len(dp02_18), name = 'yr')], axis = 1)
dp02_19 = pd.concat([dp02_19, pd.Series([2019]*len(dp02_19), name = 'yr')], axis = 1)
dp02_20 = pd.concat([dp02_20, pd.Series([2020]*len(dp02_20), name = 'yr')], axis = 1)

dp03_16 = pd.concat([dp03_16, pd.Series([2016]*len(dp03_16), name = 'yr')], axis = 1)
dp03_17 = pd.concat([dp03_17, pd.Series([2017]*len(dp03_17), name = 'yr')], axis = 1)
dp03_18 = pd.concat([dp03_18, pd.Series([2018]*len(dp03_18), name = 'yr')], axis = 1)
dp03_19 = pd.concat([dp03_19, pd.Series([2019]*len(dp03_19), name = 'yr')], axis = 1)
dp03_20 = pd.concat([dp03_20, pd.Series([2020]*len(dp03_20), name = 'yr')], axis = 1)

dp04_16 = pd.concat([dp04_16, pd.Series([2016]*len(dp04_16), name = 'yr')], axis = 1)
dp04_17 = pd.concat([dp04_17, pd.Series([2017]*len(dp04_17), name = 'yr')], axis = 1)
dp04_18 = pd.concat([dp04_18, pd.Series([2018]*len(dp04_18), name = 'yr')], axis = 1)
dp04_19 = pd.concat([dp04_19, pd.Series([2019]*len(dp04_19), name = 'yr')], axis = 1)
dp04_20 = pd.concat([dp04_20, pd.Series([2020]*len(dp04_20), name = 'yr')], axis = 1)

amenities = pd.read_csv(direc + 'data/amenities.csv')
areas = pd.read_csv(direc + 'data/area.csv')
grants = pd.read_csv(direc + 'data/grants_data.csv')
recycling = pd.read_csv(direc + 'data/recycling_data.csv')
sheds = pd.read_csv(direc + 'data/sheds.csv')
sites = pd.read_csv(direc + 'data/sites.csv')

# Merging data

fips = list(areas.FIPS)*5
names = list(areas.County)*5
years = [2016]*100 + [2017]*100 + [2018]*100 + [2019]*100 + [2020]*100
fy = [str(fips[i]) + str(years[i]) for i in range(len(fips))]

grants = pd.concat([grants, pd.Series([str(grants.FIPS[i]) + str(grants.Year[i]) for i in range(len(grants))], name = 'fy')], axis = 1)
xx = [str(recycling.FIPS[i]) + str(recycling.Year[i]) for i in range(len(recycling))]
xxx = [x[:-3] for x in xx]
recycling = pd.concat([recycling, pd.Series(xxx, name = 'fy')], axis = 1)

nature_score = [amenities[amenities['FIPS Code'] == f].reset_index(drop = True)[' 1=Low  7=High'][0] for f in fips]*5
area_vals = [areas[areas.FIPS == f].reset_index(drop = True)['Area'][0] for f in fips]*5
site_vals = [sites[sites.FIPS == f].reset_index(drop = True)['Site'][0] for f in fips]*5
shedfe = [sheds[sheds.FIPS == f].reset_index(drop = True)['Shed'][0] for f in fips]*5
prog_pcts = [sheds[sheds.FIPS == f].reset_index(drop = True)['Programs'][0] for f in fips]*5
nocounts = [sheds[sheds.FIPS == f].reset_index(drop = True)['NoCount'][0] for f in fips]*5

grant_vals = [grants[grants.fy == f].reset_index(drop = True)['Amount'][0] if f in list(grants.fy) else 0 for f in fy]
recycle_vals_total = [recycling[recycling.fy == f].reset_index(drop = True)['Total'][0] for f in fy]
recycle_vals_common = [recycling[recycling.fy == f].reset_index(drop = True)['Common'][0] for f in fy]

dp02 = pd.concat([dp02_16, dp02_17, dp02_18, dp02_19, dp02_20], axis = 0).reset_index(drop = True)
dp03 = pd.concat([dp03_16, dp03_17, dp03_18, dp03_19, dp03_20], axis = 0).reset_index(drop = True)
dp04 = pd.concat([dp04_16, dp04_17, dp04_18, dp04_19, dp04_20], axis = 0).reset_index(drop = True)

fy02 = [str(dp02.GEO_ID[i])[-5:] + str(dp02.yr[i]) for i in range(len(dp02))]
fy03 = [str(dp03.GEO_ID[i])[-5:] + str(dp02.yr[i]) for i in range(len(dp03))]
fy04 = [str(dp04.GEO_ID[i])[-5:] + str(dp02.yr[i]) for i in range(len(dp04))]

dp02 = pd.concat([dp02, pd.Series(fy02, name = 'fy')], axis = 1)
dp03 = pd.concat([dp03, pd.Series(fy03, name = 'fy')], axis = 1)
dp04 = pd.concat([dp04, pd.Series(fy04, name = 'fy')], axis = 1)

population = [int(dp02[dp02.fy == f].reset_index(drop = True)['DP02_0142E'][0]) for f in fy]
pop_density = [float(population[i]) / float(area_vals[i].replace(',','')) for i in range(len(population))]
edu_hs = [float(dp02[dp02.fy == f].reset_index(drop = True)['DP02_0067PE'][0]) for f in fy]
edu_bs = [float(dp02[dp02.fy == f].reset_index(drop = True)['DP02_0068PE'][0]) for f in fy]
edu_grad = [float(dp02[dp02.fy == f].reset_index(drop = True)['DP02_0066PE'][0]) for f in fy]
med_hhinc = [float(dp03[dp03.fy == f].reset_index(drop = True)['DP03_0062E'][0]) for f in fy]
unemployment = [float(dp03[dp03.fy == f].reset_index(drop = True)['DP03_0005PE'][0]) for f in fy]
new_houses = [float(dp04[dp04.fy == f].reset_index(drop = True)['DP04_0017PE'][0]) for f in fy]
housing_tenure = [float(dp04[dp04.fy == f].reset_index(drop = True)['DP04_0046PE'][0]) for f in fy]

fips = pd.Series(fips, name = 'FIPS')
names = pd.Series(names, name = 'County')
years = pd.Series(years, name = 'Year')
nature = pd.Series(nature_score, name = 'Amenities')
area = pd.Series(area_vals, name = 'Area')
site = pd.Series(site_vals, name = 'MRF')
shed = pd.Series(shedfe, name = 'Shed')
progpct = pd.Series(prog_pcts, name = 'Program_Pcts')
nocount = pd.Series(nocounts, name = 'NoCount')
grant = pd.Series(grant_vals, name = 'Grants')
recyc_tot = pd.Series(recycle_vals_total, name = 'Recycling_Total')
recyc_com = pd.Series(recycle_vals_common, name = 'Recycling_Common')
pop = pd.Series(population, name = 'Population')
pop_den = pd.Series(pop_density, name = 'Population_Density')
edu_hs = pd.Series(edu_hs, name = 'Education_HS')
edu_bs = pd.Series(edu_bs, name = 'Education_BS')
edu_grad = pd.Series(edu_grad, name = 'Education_MS')
med_hhinc = pd.Series(med_hhinc, name = 'Median_HH_Income')
unemp = pd.Series(unemployment, name = 'Unemployment')
new_houses = pd.Series(new_houses, name = 'New_Houses')
housing_tenure = pd.Series(housing_tenure, name = 'Housing_Tenure')

df = pd.concat([fips, names, years, nature, area, site, shed, progpct, nocount, grant, recyc_tot, recyc_com,
                pop, pop_den, edu_hs, edu_bs, edu_grad, med_hhinc, unemp, new_houses, housing_tenure], axis = 1)

# Saving to file

df.to_csv(direc + 'data/merged_data.csv', index = False)

