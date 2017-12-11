%% Lab 7: Dynamic Programming
% ISC4221, Gwen Lofman
%%
%% Problem 1
%
% Considering the set of numbers
%
% $$
% A = [12, 17, 6, 2, 8, 9, 7, 13, 19, 22, 21, 16, 18, 24, 11, 4,
%      10, 20, 5, 15, 25, 3, 23, 1, 14]
% $$
%
% We want to find the longest strictly decreasing $L \subset A$ using dynamic
% programming.  Dynamic programming is necessary because the time complexity of
% the brute force approach is exponential.
%
% $$
% \mathcal{O}\left( \sum^N_{M=1} \binom{N}{M} \right) =
% \mathcal{O}\left( 2^N - 1 \right) =
% \mathcal{O}\left( 2^N \right)
% $$
%
% This is because to find the largest possible subset for a set of numbers
% length $N$, we must consider the permutations of length $M$ for $M = \{1,
% 2, \ldots, N\}$. For set $A$ which has a length $25$, $2^N = 33,554,431$.
%
% Using dynamic programming, we establish a recursive relationship
% $L(j) = \max_{i<j} L(i)$ with $L(0) = 0$, from which we can find the largest
% subset of $A$ at each $a_i$, where
% $A = \{a_1, a_2, \ldots, a_i, \ldots, a_n\}$.  We can only choose a particular
% $L \subset A$ if the last element of $L$ is strictly less than $a_i$, and must
% backtrack if this condition is violated.  This recursive relationship will
% find a maximum subset by the time we reach the last element.  We then only
% have to find the maximum length among the $N$ resulting subsets get the
% maximum subset or maximum subsets.
%
% The time complexity of this operation in worst case is
%
% $$
% \mathcal{O}\left(\sum^N_{M=1} M \right) =
% \mathcal{O}\left(\frac{N}{2}(N-1) \right) =
% \mathcal{O}\left(N^2\right)
% $$
%
% This is because at worst case we must backtrack through all $M$ previous
% elements to find the base case for our recursion.  Dynamic programming
% makes the problem solvable in polynomial time, taking at most
% $25^2 = 625$ iterations for set $A$.

% Inline if expression
if_=@(pred,tf)tf{2-pred}();

% Anonymous function to print vector of integers as latex
vec2tex = @(v) if_(numel(v) > 1, {
    sprintf('\\{%s%i\\}', sprintf('%i, ',v(1:end-1)), v(end));
    sprintf('\\{%i\\}',v)
});

% Set initial values for dynamic programming problem
rng(12345, 'v5uniform');
A = randperm(25)';

% Gather information about the longest strictly increasing subset
[l,n,L,its] = longestsub(A);

fprintf('The largest strictly increasing subset of %s found is %s with %i elements.\n',vec2tex(A), vec2tex(l), n);

%%
% For each index $i$ of our set $A = a_{i}$, the largest subset up to
% element $a_{i}$ is listed in the table below:

fprintf('\n$$\n\\begin{tabular}{l|l}');
for i=1:numel(A)
    fprintf('\n    $a_{%2i} = %2i$ & $L_{a_{%2i}} = %s$ \\\\', i, A(i), vec2tex(cell2mat(L(i,2))));
end
fprintf('\n\\end{tabular}\n$$\n');

fprintf('\n\nTo find the solution, the algorithm used %i iterations.\n',its);
