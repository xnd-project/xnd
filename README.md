
xnd
===

xnd comprises three libraries for scientific computing:

- libndtypes provides the types required for describing typed memory blocks.
  It uses the datashape language for specifying types.

- libxnd provides typed memory blocks for CPU and GPU memory. It uses libndtypes
  for describing the memory layout and accessing memory locations.

- libgumath provides functions that operate on xnd memory blocks. It supports
  multimethods and adding new kernels at runtime.


xnd ships with the following three Python modules that map to the above
libraries.  The Python modules are included for testing the libraries, but
the libraries are not Python-specific in any way.

- ndtypes

- xnd

- gumath


The libraries and modules were written by [Stefan Krah](https://github.com/skrah).

Funding for these projects initially came from [Anaconda Inc.](https://www.anaconda.com/)
and now from [Quansight LLC](https://www.quansight.com/).
