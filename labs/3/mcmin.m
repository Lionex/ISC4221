function [ x, opt ] = mcmin( f, a, b, n )
%MCMIN perfrorms simple monte carlo minimization on a 1D function
%   
%   MCMIN(f,n) uses n points to find min of function f where points are
%   random in [0,1]
%   MCMIN(f,a,b,n) uses n points to find min of f in [a,b]
%
%   [x,m] = MCMIN(...) where and m == f(x) and is the minimum of f

% handle variadic arguments
if nargin < 3, n=a; a=0; b=1; end

% Generate n random numbers in range [a,b]
xs = a + (b-a).*rand(n,1);

[opt, I] = min(f(xs));

x = xs(I);

end

