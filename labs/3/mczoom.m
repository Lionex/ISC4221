function [ x, m, is ] = mczoom( f, a, b, n, z)
%MZOOM perfrorms simple monte carlo minimization on a 1D function
%   Will perform an adpative zoom a specified number of times to
%   theortically increase precision while also decreasing the number of
%   iterations, but with the possibility of missing the global minimum.
%
%   MZOOM(f,n,z) uses n points to find min of function f where points are
%   random in [0,1] and z is the number of zooms to perform
%   MZOOM(f,a,b,n,z) uses n points to find min of f in [a,b]
%
%   [x,m,i] = MZOOM(...) where and m == f(x), is the minimum of f, i is the
%   number of iterations

if nargin < 4, n=a; z=b; a=0; b=1; end

A = a;
B = b;
z = z+1;
is = 0;

for i=1:z
    is = is + n;
    [x,m] = mcmin(f,a,b,n);
    n = ceil(n/2);
    phi = 0.25*(b-a);
    % shrink domain with bounds checking
    if (x-phi) > A, a = x-phi; end
    if (x+phi) < B, b = x+phi; end
end
