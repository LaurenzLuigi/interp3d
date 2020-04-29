from distutils.core import setup
from Cython.Build import cythonize
from distutils.extension import Extension
from Cython.Distutils import build_ext

import numpy as np

extension = [Extension(
             'interp3d.interp',
             ['interp3d/interp.pyx'],
             extra_compile_args=['-fopenmp'],
             extra_link_args=['-fopenmp']            
             )]

setup(name='interp',
      ext_modules=cythonize(extension,  compiler_directives={'language_level':'3'}),
      packages=['interp3d'],
      include_dirs=[np.get_include()])