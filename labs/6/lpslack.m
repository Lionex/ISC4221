function [m, z, M, Z] = lpslack(A,b,c,opt)
%LPSLACK will solve linear programming for a matrix with slack variables
%
%   m = LPSLACK(A,b,c) produce vector m which maximizes z = c' * m
%   - A is the constraint matrix with slack variables
%   - c is the objective function vector on m
%   - b is the equality constraints vector on m
%
%   m = LPSLACK(A,b,c,@min) will minimize z
%
%   See also LDIVIDE, COND, NCHOOSEK, MAX, MIN

if nargin < 3, error('Not enough input arguments'); end
if nargin < 4, opt = @(x) max(x); end

if numel(c) > size(A,2), error('c is too large'); end
if numel(b) >= size(A,2), error('b has no slack variables'); end

if ~isvector(b), error('b must be a vector'); end
if ~isvector(c), error('c must be a vector'); end

if ~iscolumn(c), c=c'; end
if ~iscolumn(b), b=b'; end

% Simple utility function which simplifies the semantics of using arrayfun
% on non-uniform outputs which works as long as the outputs are vectors or
% matricies of the same size.
matrixfun = @(f,r)cell2mat(arrayfun(f,r,'UniformOutput',false));

% Determine the set of all possible rows to keep in the under-determined
% system
S = nchoosek(1:size(A,2),numel(b));

% Filter out all of the nearly singular potential matricies
S = S(arrayfun(@(i)cond(A(:,S(i,:)))<1e15,1:size(S,1)),:);

% Calculate the 'm's for all possible matricies
M = matrixfun(@(i)A(:,S(i,:))\b,1:size(S,1));

% Filter out all 'm's which do not meet constraints
filter = arrayfun(@(i)all(M(:,i)>=0),1:size(M,2));
M = M(:,filter);
S = S(filter,:);

% Insert zeros into the empty spots left by column removal, and remove
% slack variables
zed = zeros(size(A,2),size(M,2));
zed(S+(0:(size(S,1)-1))'*size(A,2)) = M';
M = zed(1:size(c),:);

% Calculate all 'z' values from the corresponding 'm's
Z = c' * M;

% Find the maximum value and corresponding index
[z, i] = opt(Z);
m = M(:,i);

end

