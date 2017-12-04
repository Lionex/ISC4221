%% Homework 4
% Gwen Lofman
%%
%% Problem 1
%
% Considering the set $\mathbf{S}$
% $$
% \{(1,2),(−4,−2),(3,3),(5,6),(−3,−1),(−5,−3),(5,4),(6,8),(−5,−2),(−1,−2)\}
% $$
X = [1  2;
    -4 -2;
     3  3;
     5  6;
    -3 -1;
    -5 -3;
     5  4;
     6  8;
    -5 -2;
    -1 -2];

figure(1);
scatter(X(:,1),X(:,2));
title('Set S');

%%
% We can cluster using dendograms of different types to see their
% properties.

D = pdist(X);
L = linkage(D,'single');

figure(2);
dendrogram(L);
title('Single-linkage Dendrogram');

%%
% (a,b) First examining single linkage dendogram we have the following
% clustering which we can interpret to mean that using, the minimum distance
% between cluster members to cluster our data-set, two obvious clusters
% appear with a minimum distance between 2 and 2.5.

D = pdist(X,'cityblock');
L = linkage(D,'single');

figure(3);
dendrogram(L);
title('City-block Dendrogram');

%%
% (c) Using the manhattan distance, or city-block distance, only checks the
% distance along axis-aligned directions, much like we would calculate
% distances as a taxi driver in Manhattan's orthgonal and regular city
% blocks; we see that the clustering is the same, but that the minimum
% distances are different.

D = pdist(X);
L = linkage(D,'complete');

figure(4);
dendrogram(L);
title('Complete-linkage Dendrogram');

%%
% (d) Using complete linkage, the scale changes somewhat since we now use
% the maximum distance to determine linkage, with the distance that
% clusters all of the data being around 16 instead of 6.  Furthermore, the
% heierarchy changes somewhat: $5$ and $10$ are clustered together frist
% rather than being clustered with $\{6,9,2\}$ first.

%% Problem 2
% Sampling 20 points $\vec{r}\in [-5,5]\times [-5,5]$ and producing the
% correspoinding voronoi tesselation we have:

X = 5 + -10.*rand(20,2);

figure(5);
voronoi(X(:,1),X(:,2));
title('Voronoi tesselation for random points');

%% Problem 3
% Given the data set from the table below, we can train a decision tree.
%
% $$
% \begin{tabular}{ccccc}
%   \hline
%   Record & A & B & C & Class \\
%   \hline
%   1 & T & T & 1 & + \\
%   2 & T & T & 6 & + \\
%   3 & T & F & 5 & - \\
%   4 & F & F & 4 & + \\
%   5 & F & T & 7 & - \\
%   6 & F & T & 3 & - \\
%   7 & F & F & 8 & - \\
%   8 & T & F & 7 & + \\
%   9 & F & T & 5 & - \\
%   \hline
% \end{tabular}
% $$

% Store as matrix, with 'T'=1, 'F'=0, '+'=1, '-'=0
% record, A, B, C, class
R = [ 1 1 1 1 1;
      2 1 1 6 1;
      3 1 0 5 0;
      4 0 0 4 1;
      5 0 1 7 0;
      6 0 1 3 0;
      7 0 0 8 0;
      8 1 0 7 1;
      9 1 1 5 0];

ent = @(p) -sum(p.*log2(p));
gini = @(p) 1-sum(p)^2;

% probability of classification as '+' for a given class and value set
P = @(c,v) arrayfun(@(i)sum(and(R(:,c) == i, R(:,5)))/numel(R(:,5)), v);

% Keep all values of X where pred is true
filter = @(pred, X) X(pred);

%%
% (a) For the dataset, the Entropy and GINI impurity for the binary
% attributes are:

p = @(c)P(c,unique(R(:,c)'));
print = @(a,g,e) fprintf('Attribute %c, GINI: %g, Entropy: %g\n',a,g,e);

A = p(2);
print('A', gini(A), ent(A));
B = p(3);
print('B', gini(B), ent(B));

%%
% And using a split of $C\leq 3$, $3 < C \leq 6$, and $C > 6$ for attribute
% C we get:

C = [ sum(and(R(:,4) <= 3, R(:,5))) / numel(R(:,5))
      sum(and(and(3 < R(:,4), R(:,4) <= 6), R(:,5))) / numel(R(:,5))
      sum(and(6 < R(:,4), R(:,5))) / numel(R(:,5))
      ];
print('C', gini(C), ent(C));

%%
% (b) Using the tables below to calculate the information gain for our
% attributes, we have:
%
% $$
% \begin{tabular}{|c|c|c|}
%   \hline
%   A & + & - \\ \hline
%   T & 3 & 1 \\ \hline
%   F & 1 & 4 \\ \hline
% \end{tabular}
% $$
%
% $$
% \mathbf{Gain}_{A} = 0.991 - \frac{4}{9} 0.8805 = 0.5997
% $$
%
% $$
% \begin{tabular}{|c|c|c|}
%   \hline
%   B & + & - \\ \hline
%   T & 2 & 3 \\ \hline
%   F & 2 & 2 \\ \hline
% \end{tabular}
% $$
%
% $$
% \mathbf{Gain}_{B} = 0.991 - \frac{5}{9} 0.9644 = 0.4553
% $$

e = ent([sum(R(:,5))/numel(R(:,5)) sum(~R(:,5))/numel(R(:,5))]');
gain = [
    e - 4/9*ent(A)
    e - 5/9*ent(B)
    e - sum([1/9*ent([0.1111 1-0.1111]) 4/9*ent([0.2222 1-0.2222]) 3/9*ent([0.1111 1-0.1111])])
];

%%
% (c) The information gain for splitting $C\leq 3$, $3 < C \leq 6$, and 
% $C > 6$ is:
%
% $$
% \begin{tabular}{|l|c|c|}
%   \hline
%   $C$           & + & - \\ \hline
%   $C\leq 3$     & 1 & 1 \\ \hline
%   $3 <C \leq 6$ & 2 & 2 \\ \hline
%   $C < 6$       & 1 & 2 \\ \hline
% \end{tabular}
% $$
%
% $$
% \mathbf{Gain}_{C} = 0.991 - \left(
%    \frac{1}{9}0.5032 + \frac{4}{9}0.7624 + \frac{3}{9}0.5032
% \right) = 0.4278
% $$
