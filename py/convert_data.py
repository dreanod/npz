import scipy.io as sio
import numpy as np

chl = np.load('../data/chl_filled.npy')
sio.savemat('../data/chl_filled.mat', {'chl': chl})