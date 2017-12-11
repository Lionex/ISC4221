function [l, n, L, its] = longestsub(A)
%LONGESTSUB will find the largest valid increasing subset recursively
%   Using dynamic programming, we can find the longest subset in O(N^2)
%   rather than O(2^N) for the brute force approach.
%
%   LONGESTSUB(A) will find the largest strictly increasing subset of
%   values from vector A, not necessarily just the sequential ones.
%
%   [l, n, L, its] = LONGESTSUB(A) outputs the longest subset l, the length
%   of that subset n, a cell array with the length and longest subset up to
%   each element a_i from set A, and the number of total iterations for the
%   algorithm its.
%
%   Examples:
%   Find the longest subset from the set { 1, 5, 10, 2, 4, 7, 9 }
%       l = LONGESTSUB([1 5 10 2 4 7 9]);
%       % l = 1 2 4 7 9
%
%   Print all of the sets and their associated lengths
%       A = randperm(25);
%       [~,~,L] = LONGESTSUB(A);
%       for i=1:numel(A)
%           Li = cell2mat(L(i,2));
%           n = cell2mat(L(i,1));
%           fprintf('%2i: %i == numel([ %s])\n', i, n, sprintf("%i ", Li));
%       end
%
% See also randperm, perms, cell2mat, max, not

if nargin < 1, error('not enough input arguments'); end
if ~isvector(A), error('A must be a vector'); end

% Initialize recursive base values for first non-recursive call
L(1,:) = {0, []};

[~,L, its] = recurse(A, L, 0);

% Process results

% Remove base recursive value
L = L(2:end,:);
[~,i] = max(cell2mat(L(:,1)));
l = cell2mat(L(i,2));
n = numel(l);

end

function [A, L, its] = recurse(A, L, its)

if nargin < 3, error('bad recursive call'); end

% Inline if expression to use inside of anonymous functions
if_=@(pred,tf)tf{2-pred}();

% Grab the tail element, providing a default if the element doesn't exist
final = @(X, e) if_(isempty(X), { @()e, @()X(end) });

% Values for convinience
a = A(1); % current element

% Rank subsets from longest to shortest by their length to get set of
% maximum elements, by sorting and then fliping to get descending order
% in terms of length
[~,I] = sort(cell2mat(L(:,1)));
I = flip(I);

% Search through valid subsets from largest to smallest to find the
% largest valid subset from the already discovered subsets using
% recursive relationship to prevent duplication of effort
for i=1:numel(I)
    i = I(i);
    if final(L{i,2}, 0) < a
        % Increment length
        len = L{i,1}+1;
        L(end+1, :) = {len; [L{i,2} a]};
        break;
    end
    its = its + 1;
end
% remove first element of A
A = A(2:end);

if numel(A) > 0
    [A, L, its] = recurse(A, L, its);
end

end
