function [ X, I ] = bubble_sort( X, comp )
%BUBBLE_SORT sort into ascending order in n^2 time complexity
%
%   Sort by comparing and swapping neighbours until they are in order,
%   essentially a brute-force sorting algorithm.
%
%   BUBBLE_SORT(A) performs sort using < as the sorting critereon
%   - if A is a vector, sort its elements in ascending order
%   - if A is a matrix, sort each row as if it was a vector
%   BUBBLE_SORT(A, comp) performs sort using the comparison function
%   which returns false if the values are not in the desired order. It must
%   accept two arguments x from xs.  The default function is:
%
%      comp = @(x,y) x(1) > y(1)
%
%   [X, I] = BUBBLE_SORT(A) returns the sorted elements X and and sort
%   indecies I where
%   - If A is a vector, then B = A(I).  
%   - If A is an m-by-n matrix, then B = A(I,:)
%
%   See also SELECT_SORT, SORT

% Handle variadic arguments

if nargin < 2, comp = @(x,y) x(1) > y(1); end

if isvector(X), I=1:numel(X); else I=1:size(X,1); end
n=numel(I);

swap = true;
while swap
    swap = false;
    % Percolate the current element into position as long as we have 
    % elements out of sort order
    for i = 2:n
        % Swap elements futher down the list until that element is in the
        % proper order
        if comp(X(i-1,:), X(i,:))
            X([i i-1],:) = X([i-1 i],:);
            I([i i-1]) = I([i-1 i]);
            swap = true; 
        end
    end
    n=n-1;
end

end