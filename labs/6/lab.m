%% Lab 6: Discrete Optimization
% Gwen Lofman
%%
%% Linear Programming
% The function $\verbatim{lpslack}$ will maximize
% $z = \vec{c}^\mathbf{T}\vec{m}$ given a constraint matrix $\text{A}$ with
% slack variables and corresponding constraints vector $\vec{b}$.
%
% Using the example problem $\max z = 120x_1 + 100x_2$ subject to the
% constraints $2x_1 + 2x_2 \leq 8, 5x_1 + 3x_2 \leq 15, x_1,x_2 \geq 0$ to
% test $\verbatim{lpslack}$, we find the maximum solution to be

A = [2 2 1 0; 5 3 1 0];
b = [8 15];
c = [120; 100];

[m,z] = lpslack(A,b,c)


%%
