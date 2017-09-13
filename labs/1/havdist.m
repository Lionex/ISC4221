function [ D ] = havdist( t1, p1, t2, p2, r )
%HAVDIST great-circle distance between two points on a sphere
%
%   Used to approximate distance between two geographical locations in
%   latitutde longitude assuming the shape of the earth as a sphere.
%
%   Unless otherwise specified, HAVDIST assumes a sphere radius of 1.  The
%   units of the output are the units of the radius.
%
%   HAVDIST(t1, p1, t2, p2) will calculate the haversine distance between 
%   points (t1,p1) and (t2,p2) where t1, p1, t2, and p2 are scalars or
%   vectors of the same size.
%
%   HAVDIST(L1, L2) where L1 and L2 have size [2, n] will calculate the 
%   haversine distance between each row of points, using the first value in
%   using the first column of each matrix as the latitude and the second as
%   the longitude.  Note that:
%
%       HAVDIST(L1, L2) == HAVDIST(L1(:,1), L1(:,2), L2(:,1), L2(:,2))
%
%   HAVDIST(t1, p1, t2, p2, r) and HAVDIST(L1, L2, r) calculate the
%   distance on a sphere with radius r.  Note that:
%
%       HAVDIST(..., r) == r .* HAVDIST(...)
%
%   See also DIST, DISTANCES, MANDIST, NEGDIST, BOXDIST


%% Handle variadic arguments & input validation

% Assign r to desired value or a radius of 1
if nargin == 3, r = t2; elseif nargin ~= 5, r = 1; end

% preallocate D to proper output size
if isvector(t1), D = zeros(size(t1)); else D = zeros(size(t1,1),1); end

samesize = @(A,B) all(size(A)==size(B));

% Provide better error messages
if ~isscalar(r) && ~samesize(r,D), error('r vector size mismatch'); end
if nargin<4 && ~samesize(t1,p1), error('matrix dimensions must agree'); end


%% Define haversine operation

% Define the haversine function
hav = @(T) (1-cos(T)) ./ 2;

% Haversine formula for calculating the distance between two points
f = @(t1,p1,t2,p2) hav(t2-t1) + cos(t2).*cos(t1).*hav(p2-p1);

% Inverse of the haversine formula f provides the distance; assuming r=1 to
% defer the calculation with the proper radius r to allow vectorized input
d = @(t1,p1,t2,p2) 2 .* asin(sqrt( f(t1,p1,t2,p2) ));


%% Calculate results

% Pass the columns of each matrix to distance formula
if nargin < 4, D = r .* d(t1(:,1), t1(:,2), p1(:,1), p1(:,2)); end

% Pass input vectors to distance formula
if nargin > 3, D = r .* d(t1, p1, t2, p2); end

end

