function [ X ] = bubble_sort( X, comp )
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
%      comp = @(x,y) x > y
%
%   See also SELECT_SORT

% Handle variadic arguments

if nargin < 2, comp = @(x,y) x > y; end

if isvector(X)
    % Bubble sort the vector
    X=bubble(X,comp);
else
    % Bubble sort each row of the matrix
    for row=1:size(X,1), X(row,:)=bubble(X(row,:),comp); end
end

end

function [ xs ] = bubble(xs,comp)
% Perform the actual sort

n=numel(xs);

swap = true;
while swap
    swap = false;
    % Percolate the current element into position as long as we have 
    % elements out of sort order
    for i = 2:n
        % Swap elements futher down the list until that element is in the
        % proper order
        if comp(xs(i-1),xs(i)), xs([i i-1]) = xs([i-1 i]); swap = true; end
    end
    n=n-1;
end

end