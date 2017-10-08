%% Homework 1
% Gwen Lofman, ISC4221
%%
%% 1. Algorithm Efficiency
clear all;

n = 10.^(1:0.1:5)';

m = [n n.^2 2.^n n.^3 n.*log(n) log10(n) 4.^n factorial(ceil(n))];

figure;
loglog(n,m);
title('time complexity');
xlabel('n');
legend('n','n^2','2^n','n^3','nlog(n)','log_{10}(n)','4^n','n!');

%%
% Ordered by overall efficiency, the best to worst functions in terms of
% time complexity are:
% $$
% \begin{tabular}{ l | rrrr }
%   10^n & log_{10}(n) & n      & nlog(n) & n^2         \\
%   \hline
%   1    & 1           & 10     & 23      & 100         \\
%   2    & 2           & 100    & 461     & 10000       \\
%   3    & 3           & 1000   & 6907    & 1000000     \\
%   4    & 4           & 10000  & 92103   & 100000000   \\
%   5    & 5           & 100000 & 1151292 & 10000000000 \\
% \end{tabular}
% $$
%
% $$
% \begin{tabular}{ l | rrrr }
%   10^n & n^3              & 2^n           & 4^n         & n!           \\
%   \hline
%   1    & 1000             & 1024          & 1.048e^{6}  & 3.628e^{6}   \\
%   2    & 1000000          & 1.267e^{30}   & 1.606e^{60} & 9.332e^{156} \\
%   3    & 1000000000       & 1.0715e^{301} & inf         & inf          \\
%   4    & 1000000000000    & inf           & inf         & inf          \\
%   5    & 1000000000000000 & inf           & inf         & inf          \\
% \end{tabular}
% $$
%%
% A simple method exists to order the functions based on their efficiency:
%
%    f = {'n','n^2','2^n','n^3','nlog(n)','log_{10}(n)','4^n','n!'};
%
%    n = 10.^(1:5)';
%
%    m = [n n.^2 2.^n n.^3 n.*log(n) log10(n) 4.^n factorial(ceil(n))];
%
%    [m I] = sort(m');
%
%    f(I(:,1))' % functions sorted by efficiency
%%
% Comparing $nlog(n)^2$ to $n^d$ for $d=1,2$ shows that $nlog(n)^2$
% falls between $n^1$ and $n^2$ in terms of time complexity.
clear m n;

n = 10.^(1:6)';
m = [n.*log(n).^2 n n.^2];

figure;
loglog(n,m(:,1),'-',n,m(:,2:size(m,2)),'--');
title('nlog(n)^2 vs n^{1,2}');
xlabel('n');
legend('nlog(n)^2','n','n^2');

%% 2. Assignment Problem
% Given the following cost matrix:
%
% $$
% \begin{tabular}{lccc}
%       Person & Job 1 & Job 2 & Job 3 \\
%       \hline
%       A      & $9    & $2    & $7    \\
%       B      & $6    & $4    & $3    \\
%       C      & $5    & $8    & $1    \\
% \end{tabular}
% $$
%
% We find the minimal assignment combination using exhaustion.

cost = [9 2 7; 6 4 3; 5 8 1];

% This is surprisingly hard to vectorize. I was hoping to take advantage of
% matlab's indexing rules but no dice, ended up having to write for loops.

ps = perms(1:3);

min = inf;
for p=1:size(ps,1) % iterate through permutations
    i=ps(p,:); % grab the current set of permutations
    sum = 0;
    fprintf('permutation %d;\n',p);
    for j=1:3 % iterate through jobs
        sum = sum + cost(j,i(j));
        fprintf('\tperson  %d, job %d for $%d\n',j,i(j),cost(j,i(j)));
    end
    fprintf('\t\ttotal = $%d\n',sum);
    if sum < min, min = sum; end
end

fprintf('minimum cost %d\n', min);

%% 3. Insertion Sort
% The insertion sort on ${15,3,5,29,42,12}$ takes the following steps:
%
% $$
% \begin{tabular}{c}
%     {15,3,5,29,42,12} \\
%     \hline
%     {3,15,5,29,42,12} \\
%     {3,5,15,29,42,12} \\
%     {3,5,15,29,42,12} \\
%     {3,4,15,29,42,12} \\
%     \hline
%     {3,4,12,15,29,42} \\
% \end{tabular}
% $$