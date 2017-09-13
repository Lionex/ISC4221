function [ X, I ] = select_sort( X, comp )
%SELECT_SORT sort a list into ascending order in n^2 time complexity
%
%   SELECT_SORT will sort in-place, selecting the next element in order
%   and swapping it into place.
%
%   SELECT_SORT(A) performs sort using < as the sorting criteron
%   - if A is a vector, sort its elements in ascending order
%   - if A is a matrix, sort the rows of the matrix by their first element
%   SELECT_SORT(A, comp) performs sort using the comparison function
%   which returns false if the values are not in the desired order. It must
%   accept two arguments x from xs.  The default function is:
%
%      comp = @(x,y) x(1) < y(1)
%
%   [X, I] = SELECT_SORT(A) returns the sorted elements X and and sort
%   indecies I where
%   - If A is a vector, then B = A(I).  
%   - If A is an m-by-n matrix, then B = A(I,:)
%
%   See also BUBBLE_SORT, SORT

% Handle variadic arguments

if nargin < 2; comp = @(x,y) x(1) < y(1); end

if isvector(X), I=1:numel(X); else I=1:size(X,1); end
els=numel(I);

% Perform algorithm

for e=1:els
    % Assume the current element is the minimum unsorted element
    min = e;

    % Iterate through the list to see if the next element is the minimum
    for m=e:els, if comp(X(m,:), X(min,:)), min=m; end; end

    % Swap the current element with the found minimum element
    X([min e],:) = X([e min],:);
    I([min e]) = I([e min]);
end

end