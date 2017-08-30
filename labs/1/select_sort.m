function [ X ] = select_sort( X, comp )
%SELECT_SORT sort a list into ascending order in n^2 time complexity
%
%   SELECT_SORT will sort in-place, selecting the next element in order
%   and swapping it into place.
%
%   SELECT_SORT(A) performs sort using < as the sorting criteron
%   - if A is a vector, sort its elements in ascending order
%   - if A is a matrix, sort each row as if it was a vector
%   SELECT_SORT(A, comp) performs sort using the comparison function
%   which returns false if the values are not in the desired order. It must
%   accept two arguments x from xs.  The default function is:
%
%      comp = @(x,y) x < y
%
%   See also BUBBLE_SORT

% Handle variadic arguments

if nargin < 2; comp = @(x,y) x < y; end

if isvector(X)
    % Select sort the vector's elements
    X = select(X);
else
    % Select sort each row of the matrix
    for row=1:size(X,1), X(row,:) = select(X(row,:),comp); end
end

end

function [xs] = select(xs, comp)
% perform the actual sort

els=numel(xs);
% Perform algorithm

for e=1:els
    % Assume the current element is the minimum unsorted element
    min = e;

    % Iterate through the list to see if the next element is the minimum
    for m=e:els, if comp(xs(m),xs(min)), min=m; end; end

    % Swap the current element with the found minimum element
    xs([min e]) = xs([e min]);
end

end