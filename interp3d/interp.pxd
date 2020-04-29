cimport numpy as np
cpdef np.float_t[:] _interp3D(np.float_t[:,:,::1] v, np.float_t[::1] x, np.float_t[::1] y, np.float_t[::1] z, np.float_t[:] res, int X, int Y, int Z, int num, np.float_t minx, np.float_t miny, np.float_t minz, np.float_t delx, np.float_t dely, np.float_t delz)

