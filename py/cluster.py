import numpy as np
from sklearn.cluster import MeanShift

mask = np.load('../data/mask_land.npy')
chl = np.load('../data/chl_filled.npy')

chl_col = chl[~mask, :50]

from sklearn.cluster import MeanShift
ms = MeanShift()
ms.fit(chl_col)
labels = ms.labels_

cluster_centers = ms.cluster_centers_
labels_unique = np.unique(labels)
n_clusters_ = len(labels_unique)

print("number of estimated clusters : %d" % n_clusters_)

###############################################################################
# Plot result

labels_img = ma.zeros(mask.shape)
labels_img.mask = mask
labels_img[~mask] = labels


import matplotlib.pyplot as pl
pl.imshow(labels_img)