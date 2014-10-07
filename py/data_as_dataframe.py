import pandas as pd
import numpy as np

mask = np.load('../data/mask_land.npy')
chl = np.load('../data/chl_filled.npy')
[nlat, nlon, T] = chl.shape

lon = np.load('../data/longitudes.npy')
lon = np.tile(lon, (nlat, 1))
lat = np.load('../data/latitudes.npy')
lat = np.tile(lat[:,np.newaxis], (1, nlon))

chl = chl[~mask, :]
lon = lon[~mask]
lat = lat[~mask]

ind = pd.date_range(start='01-01-1998', periods=46, freq='8D')
for year in range(1999, 2005):
    startdate = '01-01-' + str(year)
    tmp = pd.date_range(start=startdate, periods=46, freq='8D')
    ind = ind.append(tmp)

df = pd.DataFrame(chl, columns=ind)
df['lon'] = lon
df['lat'] = lat

df.to_csv('../data/chl_df.csv')