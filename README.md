A marginally faster 3D interpolation compared to `scipy.interpolate.RegularGridInterpolator()`

Forked from interp3d by jglaser (https://github.com/jglaser/interp3d)

Installation (requires **cython** and Microsoft Visual Studio (for parallelization))

```
python3 setup.py install
```

Usage:

```
from interp3d import interp_3d
import numpy as np

x = np.linspace(0,2.5,100)
y = np.linspace(-1,.5,50)
z = np.linspace(5,25,125)

X,Y,Z = np.meshgrid(x,y,z,indexing='ij')
arr = X+2*Y-3*Z

interp = interp_3d.Interp3D(arr, x,y,z)

from scipy.interpolate import RegularGridInterpolator
interp_si = RegularGridInterpolator((x,y,z),arr)

x0 = [0, 0.5]
y0 = [0, 0.1]
z0 = [5, 15]
exact = [x + 2*y -3*z for (x,y,z) in np.c_[x0,y0,z0]]

print('this class {}'.format(interp(np.c_[x0,y0,z0],1)))
print('scipy.interpolate.RegularGridInterpolator() {}'.format(interp_si(np.c_[x0,y0,z0])))
print('exact ', exact)
```
