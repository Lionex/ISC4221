%% Lab 6: Discrete Optimization
% Gwen Lofman
%%
%% Linear Programming
% The function $\mathbf{lpslack}$ will maximize
% $z = \vec{c}^\mathbf{T}\vec{m}$ given a constraint matrix $\text{A}$ with
% slack variables and corresponding constraints vector $\vec{b}$.
%
% Using the example problem $\max z = 120x_1 + 100x_2$ subject to the
% constraints $2x_1 + 2x_2 \leq 8, 5x_1 + 3x_2 \leq 15, x_1,x_2 \geq 0$ to
% test $\mathbf{lpslack}$, we find the maximum solution to be

A = [2 2 1 0; 5 3 1 0];
b = [8 15];
c = [120; 100];

[m,z] = lpslack(A,b,c)


%% Green Sawmill Company
% We want to maximize profits by minimizing transportation costs between
% logging sites and sawmills.  Each requires a specific ammount of
% truckloads.
%
% For each logging site, the number of truckloads is:
% $$ s_1 \leq 20, s_2 \leq 30, s_3 \leq 45 $$
%
% For each mill, the number of truckloads is:
% $$ m_1 \geq 30, m_2 \geq 35, m_1 \geq 30 $$
%
% Given cost matrix $\text{C}$ in dollars where each row represents a
% logging site and each column a mill:
% $$
% \[\begin{pmatrix}
%   16 & 30 & 100 \\ 20 & 34 & 40 \\ 60 & 52 & 30
% \end{pmatrix}\]
% $$
%
% We can structure our problem as a linear programming problem such that we
% have our constraint matrix with slack variables, which were truncated
% here to keep the matrix on the page.  Slack variables can be added with
% $\begin{verbatim}A = [A diag([1 1 1 -1 -1 -1])]\end{verbatim}$.
%
% $$
% \text{A} =
% \[\begin{pmatrix}
%   1 & 1 & 1 & 0 & 0 & 0 & 0 & 0 & 0 \\
%   0 & 0 & 0 & 1 & 1 & 1 & 0 & 0 & 0 \\
%   0 & 0 & 0 & 0 & 0 & 0 & 1 & 1 & 1 \\
%   0 & 0 & 0 & 0 & 0 & 0 & 1 & 1 & 1 \\
%   1 & 0 & 0 & 1 & 0 & 0 & 1 & 0 & 0 \\
%   0 & 1 & 0 & 0 & 1 & 0 & 0 & 1 & 0 \\
%   0 & 0 & 1 & 0 & 0 & 1 & 0 & 0 & 1 
% \end{pmatrix}\]
% $$
%
% and corresponding constraint vector
%
% $$
% \vec{b} = \{s_1,s_2,s_3,m_1,m_2,m_3\} = \{20,30,45,30,35,30\}
% $$

% Define hauling cost between each mill and plant
D = [8 15 50; 10 17 20; 30 26 15];
C = 2*D;
c = reshape(C',numel(C),1);

A = [1 1 1 0 0 0 0 0 0 1 0 0  0  0  0;
     0 0 0 1 1 1 0 0 0 0 1 0  0  0  0;
     0 0 0 0 0 0 1 1 1 0 0 1  0  0  0;
     1 0 0 1 0 0 1 0 0 0 0 0 -1  0  0;
     0 1 0 0 1 0 0 1 0 0 0 0  0 -1  0;
     0 0 1 0 0 1 0 0 1 0 0 0  0  0 -1];

b = [20; 30; 45; 30; 35; 30];

[m,z,M,Z] = lpslack(A,b,c,@min);

% filter out all repeated values
[M,I] = unique(M','rows'); M = M';
Z = Z(I);

fprintf('Minimum cost $\\vec{c}^\\mathbf{T}\\cdot\\vec{m}=\\$%i$ ',z);
fprintf('found for $\\vec{m} = \\{%i,%i,%i,%i,%i,%i,%i,%i,%i\\}$\n',m);

fprintf('From solution set\n');
for i=1:size(M,2)
    fprintf('$$\n');
    fprintf('\\vec{c}^\\mathbf{T} \\cdot \\vec{m}_{%i} = \\$%i;\n',i,Z(i));
    fprintf('\\vec{m}_{%i} =  \\{%i,%i,%i,%i,%i,%i,%i,%i,%i\\}\n',i,M(:,i));
    fprintf('$$\n');
end

%%
% Solution set truncated for readability by removing duplicate feasible
% solutions.
