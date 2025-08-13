# ND-array

## The N-dimensional array (ndarray)


contiguous one-dimensional segment of computer memory

NumPy ndarray internals can be read in <a href='https://github.com/numpy/numpy/blob/master/numpy/core/include/numpy/ndarraytypes.h' target='_blank'>source code </a>



```c

typedef struct tagPyArrayObject_fields {
    PyObject_HEAD
    /* Pointer to the raw data buffer */
    char *data;
    /* The number of dimensions, also called 'ndim' */
    int nd;
    /* The size in each dimension, also called 'shape' */
    npy_intp *dimensions;
    /*
     * Number of bytes to jump to get to the
     * next element in each dimension
     */
    npy_intp *strides;
    /*
     * This object is decref'd upon
     * deletion of array. Except in the
     * case of WRITEBACKIFCOPY which has
     * special handling.
     *
     * For views it points to the original
     * array, collapsed so no chains of
     * views occur.
     *
     * For creation from buffer object it
     * points to an object that should be
     * decref'd on deletion
     *
     * For WRITEBACKIFCOPY flag this is an
     * array to-be-updated upon calling
     * PyArray_ResolveWritebackIfCopy
     */
    PyObject *base;
    /* Pointer to type structure */
    PyArray_Descr *descr;
    /* Flags describing array -- see below */
    int flags;
    /* For weak references */
    PyObject *weakreflist;
} PyArrayObject_fields;


```

Papers:

- https://jakevdp.github.io/PythonDataScienceHandbook/02.01-understanding-data-types.html
- <a href='https://docs.scipy.org/doc/numpy/reference/arrays.ndarray.html' target='_blank'>NumPy documentation</a>
- https://github.com/numpy/numpy/blob/b7c27bd2a3817f59c84b004b87bba5db57d9a9b0/numpy/core/include/numpy/ndarraytypes.h#L1343



ndarray.flags 	Information about the memory layout of the array.
ndarray.shape 	Tuple of array dimensions.
ndarray.strides 	Tuple of bytes to step in each dimension when traversing an array.
ndarray.ndim 	Number of array dimensions.
ndarray.data 	Python buffer object pointing to the start of the array’s data.
ndarray.size 	Number of elements in the array.
ndarray.itemsize 	Length of one array element in bytes.
ndarray.nbytes 	Total bytes consumed by the elements of the array.
ndarray.base 	Base object if memory is from some other object.


![ndarray](https://docs.scipy.org/doc/numpy/_images/threefundamental.png)