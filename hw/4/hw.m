%% Homework 4
% Gwen Lofman
%%
%% Problem 1
%
% Considering the set $\mathbf{S}$
% $$
% \{(1,2),(−4,−2),(3,3),(5,6),(−3,−1),(−5,−3),(5,4),(6,8),(−5,−2),(−1,−2)\}
% $$
%
% We can cluster using dendograms of different types to see their
% properties.
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
% (a,b) First examining single linkage dendogram we have the following
% clustering which we can interpret to mean that using, the minimum distance
% between cluster members to cluster our data-set, two obvious clusters
% appear with a minimum distance between 2 and 2.5.

D = pdist(X);
L = linkage(D,'single');

figure(2);
dendrogram(L);
title('Single-linkage Dendrogram');

%%
% (c) Using the manhattan distance, or city-block distance, only checks the
% distance along axis-aligned directions, much like we would calculate
% distances as a taxi driver in Manhattan's orthgonal and regular city
% blocks; we see that the clustering is the same, but that the minimum
% distances are different.

D = pdist(X,'cityblock');
L = linkage(D,'single');

figure(3);
dendrogram(L);
title('City-block Dendrogram');

%%
% (d) Using complete linkage, the scale changes somewhat since we now use
% the maximum distance to determine linkage, with the distance that
% clusters all of the data being around 16 instead of 6.  Furthermore, the
% heierarchy changes somewhat: $5$ and $10$ are clustered together frist
% rather than being clustered with $\{6,9,10\}$ first.

D = pdist(X);
L = linkage(D,'complete');

figure(4);
dendrogram(L);
title('Complete-linkage Dendrogram');

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
%   \text{record} & \mathbf{A} & \mathbf{B} & \mathbf{C} & \text{Class} \\
%   1 & \text{T} & \text{T} & 1 & \text{+} \\
%   2 & \text{T} & \text{T} & 6 & \text{+} \\
%   3 & \text{T} & \text{F} & 5 & \text{-} \\
%   4 & \text{F} & \text{F} & 4 & \text{+} \\
%   5 & \text{F} & \text{T} & 7 & \text{-} \\
%   6 & \text{F} & \text{T} & 3 & \text{-} \\
%   7 & \text{F} & \text{F} & 8 & \text{-} \\
%   8 & \text{T} & \text{F} & 7 & \text{+} \\
%   9 & \text{F} & \text{T} & 5 & \text{-}
% \end{tabular}
% $$

%%
% (a) For each record, the Entropy and GINI impurity:

%%
% (b) And the information gain for our binary attributes is:

%%
% (c) The information gain for splitting $C\leq 3$
