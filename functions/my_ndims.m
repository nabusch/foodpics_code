function ndims = my_ndims(x)
% function ndims = my_ndims(x)
% Return the number of NON-SINGLETON DIMENSIONS of a matrix x.

ndims = sum(size(x)>1);
