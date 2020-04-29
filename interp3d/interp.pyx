cimport numpy as np
import numpy as np
from libc.math cimport floor
from cython cimport boundscheck, wraparound, nonecheck, cdivision
from cython.parallel import prange, parallel, threadid
from libc.stdio cimport printf
#from timeit import default_timer as timer

@boundscheck(False)
@wraparound(False)
@cdivision(True)
cpdef np.float_t[:] _interp3D(np.float_t[:,:,::1] v, np.float_t[::1] xs, np.float_t[::1] ys, np.float_t[::1] zs, np.float_t[:] result, int X, int Y, int Z, int num, np.float_t minx, np.float_t miny, np.float_t minz, np.float_t delx, np.float_t dely, np.float_t delz):

    # start = timer()
    cdef:
        int i, x0, x1, y0, y1, z0, z1, dim, thread_id	
        np.float_t xd, yd, zd, c00, c01, c10, c11, c0, c1, c
        np.float_t *v_c
        np.float_t *x_c
        np.float_t *y_c
        np.float_t *z_c
        np.float_t x, y, z
		
    dim = int(len(xs))  
    x_c = &xs[0]
    y_c = &ys[0]
    z_c = &zs[0]
	
    for i in range(dim):
        x_c[i] = xs[i]
        y_c[i] = ys[i]
        z_c[i] = zs[i]	
	
    v_c = &v[0,0,0]
    # print('definition time for {} threads: {}'.format(num, timer()-start))
	
    # start = timer()
    with nogil, parallel(num_threads=num):
        for i in prange(dim,schedule='static'):
            x = (x_c[i] - minx)/delx
            y = (y_c[i] - miny)/dely	
            z = (z_c[i] - minz)/delz
			
            x0 = <int>floor(x)
            x1 = x0 + 1
            y0 = <int>floor(y)
            y1 = y0 + 1
            z0 = <int>floor(z)
            z1 = z0 + 1

            xd = (x-x0)/(x1-x0)
            yd = (y-y0)/(y1-y0)
            zd = (z-z0)/(z1-z0)
			
            if x0 >= 0 and y0 >= 0 and z0 >= 0 and x1 <= X and y1 <= Y and z1 <= Z :
                c00 = v_c[Y*Z*x0+Z*y0+z0]*(1-xd) + v_c[Y*Z*x1+Z*y0+z0]*xd
                c01 = v_c[Y*Z*x0+Z*y0+z1]*(1-xd) + v_c[Y*Z*x1+Z*y0+z1]*xd
                c10 = v_c[Y*Z*x0+Z*y1+z0]*(1-xd) + v_c[Y*Z*x1+Z*y1+z0]*xd
                c11 = v_c[Y*Z*x0+Z*y1+z1]*(1-xd) + v_c[Y*Z*x1+Z*y1+z1]*xd

                c0 = c00*(1-yd) + c10*yd
                c1 = c01*(1-yd) + c11*yd

                c = c0*(1-zd) + c1*zd
            else:
                c = 0
		  
            result[i] = c
    # print('calculation time for {} threads: {}'.format(num, timer()-start))
    return result
