%% Homework 2
% Gwen Lofman, ISC4221
%%
%% Loaded dice
% For a pair of dice with the probabilities $\frac{1}{10}$, $\frac{0}{10}$,
% $\frac{1}{10}$, $\frac{2}{10}$, $\frac{4}{10}$, $\frac{2}{10}$ for $1$ to
% $6$ respectively, the probability table for two dice throws is as
% follows.

% Create the distribution as a vector
p = [1 0 1 2 4 2]./10;

% Calculate probability distribution table
P = p' * p;

%%%
% $$
% \begin{tabular}{l|c|c|c|c|c|c}
%     side & 1    & 2 & 3    & 4    & 5    & 6 \\
%     \hline
%     1    & 0.01 & 0 & 0.01 & 0.02 & 0.04 & 0.02 \\
%     2    & 0    & 0 & 0    & 0    & 0    & 0    \\
%     3    & 0.01 & 0 & 0.01 & 0.02 & 0.04 & 0.02 \\
%     4    & 0.02 & 0 & 0.02 & 0.04 & 0.08 & 0.04 \\
%     5    & 0.04 & 0 & 0.04 & 0.08 & 0.16 & 0.08 \\
%     6    & 0.02 & 0 & 0.02 & 0.04 & 0.08 & 0.04 \\
% \end{tabular}
% $$

% Ensure total probability sums to one
total = sum(reshape(P,numel(P),1));
if abs(total - 1) > 0.001, error('total %g is not 1', total); end

%%%
% Their probabilities sum to 1.

%%%
% We can also observe the probability distribution for the sums of the dice
% pairs by plotting the discrete PDF of the sums.

% Generate all possible pairs of dice numbers
N = [nchoosek(1:6,2); repmat((1:6)',1,2); fliplr(nchoosek(1:6,2))];

% Sum for each pair
n = sum(N,2);

% probability distribution of each pair
P_N = P(6*N(:,1)+N(:,2)-6);

% Probability distribution for each sum
P_N = arrayfun(@(s)sum(P_N(n == s)),2:12)';

% Ensure total probability sums to one
if abs(sum(P_N) - 1) > 0.001, error('total %g is not 1', sum(P_N)); end

figure(1);
plot(2:12,P_N,'.-');
title('Dice Sum Probability Density');
xlabel('dice number');
ylabel('probability');

%%
% $$
% \begin{tabular}{c|c|c|c|c|c|c|c|c|c|c|c}
% 2    &
3 & 4    & 5    & 6    & 7    & 8    & 9   & 10   & 11   & 12 \\
% \hline
% 0.01 & 0 & 0.02 & 0.04 & 0.09 & 0.08 & 0.12 & 0.2 & 0.24 & 0.16 & 0.04 \\
% \end{tabular}
% $$

rng(56789); % set seed specified by homework for easy grading