function [ x, m, is ] = mczoom( f, a, b, n, z)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

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
