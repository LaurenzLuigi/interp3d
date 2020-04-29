from .interp import _interp3D
import numpy as np
from cython import boundscheck, wraparound
#from timeit import default_timer as timer

class Interp3D(object):
    @boundscheck(False)
    @wraparound(False)
    def __init__(self, v, x, y, z):
        self.v = v
        self.min_x, self.max_x = x[0], x[-1]
        self.min_y, self.max_y = y[0], y[-1]
        self.min_z, self.max_z = z[0], z[-1]
        self.delta_x = (self.max_x - self.min_x)/(x.shape[0]-1)
        self.delta_y = (self.max_y - self.min_y)/(y.shape[0]-1)
        self.delta_z = (self.max_z - self.min_z)/(z.shape[0]-1)

    @boundscheck(False)
    @wraparound(False)
    def __call__(self, t, num):
        X,Y,Z = self.v.shape[0], self.v.shape[1], self.v.shape[2]

        x = np.ascontiguousarray(t[:,0])
        y = np.ascontiguousarray(t[:,1])
        z = np.ascontiguousarray(t[:,2])
        res = t[:,2]
		
        return np.asarray(_interp3D(self.v, x, y, z, res, X, Y, Z, num, self.min_x, self.min_y, self.min_z, self.delta_x, self.delta_y, self.delta_z))
