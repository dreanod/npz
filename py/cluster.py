import numpy as np
from sklearn.cluster import MeanShift
import pandas as pd
import matplotlib.pyplot as pl

df = pd.read_csv('../data/chl_df.csv')

## Only consider northern Red Sea
df_north = df[df.lat > 25]
df_north = df_north[df_north.lat < 28]

## Extract chl values:
chl = df_north.values[:, 1:-2]

## Fitting MeanShift model
ms = MeanShift()
ms.fit(chl)
labels = ms.labels_

## Plot result
pl.scatter(df_north.lon, df_north.lat, c=labels)
pl.show()

