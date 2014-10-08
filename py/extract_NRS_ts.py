import numpy as np
import pandas as pd

df = pd.read_csv('../data/chl_df.csv')

df = df[df.lat < 28]
df = df[df.lat > 25.5]

chl = df.values[:, 1:-2]

chl_ts = chl.mean(axis=0)

dates = df.columns[1:-2]
chl_ts = pd.Series(chl_ts, index = dates)

chl_ts.to_csv('../data/TS_NRS.csv')