%% Random Processes
% Gwen Lofman, ISC4221
%%
%% Monte Carlo Optimization
%
% We use monte carlo optimization to find the minimum value of the
% functions:
%
% $$
% \begin{tabular}{rcll}
%     $f_1$ & = & $\left| cos(\pi x) \right|$ & [0,1]\\
%     &&&\\
%     $f_2$ & = & $cos(x)+5cos(x)-2cos(2x)+5cos(4.5x)+7cos(9x)$ & $[2,7]$ \\
%     &&&\\
%     $f_3$ & = & $-\left[sech^2(10(x-2))+sech^2(100(x-4))+sec^2(1000(x-6))\right]$ & $[0,1]$ \\
% \end{tabular}
% $$
%

% Define functions
f1 = @(x) abs(cos(pi.*x));
f2 = @(x) cos(x) + 2*cos(2*x) + 5*cos(4.5*x) + 7*cos(9*x);
f3 = @(x) -sech(10*(x-2)).^2 - sech(100*(x-4)).^2 - sech(1000*(x-6)).^2;

figure(1);
xs = linspace(0,1,1000);
ys = f1(xs);
[y, x] = min(ys);
subplot(3,1,1), plot(xs,ys,'r',xs(x),y,'ro');
title('Functions over their domains');
legend('f_1');

xs = linspace(2,7,1000);
ys = f2(xs);
[y, x] = min(ys);
subplot(3,1,2), plot(xs,ys,'b',xs(x),y,'bo');
legend('f_2');

xs = linspace(0,1,1000);
ys = f3(xs);
[y, x] = min(ys);
subplot(3,1,3), plot(xs,ys,'m',xs(x),y,'mo');
legend('f_3');

%%
% From the plots we can visually estimate the global minima:
%
% $$
% \begin{tabular}{|c|c|}
%   \hline
%   function & $x_{min}$ \\
%   \hline
%   $f_1$ & $0.5$ \\
%   $f_2$ & $4.6$ \\
%   $f_3$ & $1$   \\
%   \hline
% \end{tabular}
% $$
%%
% Using a simple implementation of the Monte Carlo optimization sampling
% algorithm, we can test our values on the $abs(cos(\pi x))$, where we know
% analytically that the minimum is $0.5$.

runs = 10; % determine number of runs to perform

% define necessary quantities and perform mcmin multiple times over a range
% of sample sizes

f = @(x) abs(cos(pi.*x)); % define function to test minimization on
n = 25*(2.^(0:6))'; % create range of sample sizes
m = arrayfun(@(n)mcmin(f,n),repmat(n,1,runs)); % repeat mcmin `runs` times

avgerr = mean(abs(0.5-m),2); % compute mean absolute error
avg = mean(m,2); % compute the mean minimum value

figure(2);
loglog(n,avgerr,'r',n,abs(0.5-m),'k.');
title('Monte Carlo |cos(\pi x)|');
ylabel('error_{abs}');
xlabel('samples');
legend('mean');

%%

fprintf('        samples   | mean optima | mean error\n')
fprintf('        ----------|-------------|-----------\n')
fprintf('        %8i  |  %1.7g\t | %1.7g\n',[n mean(m,2) avgerr]')

%%
% We can modify the monte carlo optimization algorithm to perform less
% function evaluations by zooming and sampling smaller subsets of the
% domain around the local minima we find.
%
% Plotting absolute error against the sample size and number of zooms for
% $f_1$ and $f_2$ we have:

% Create a grid of zoom and sample sizes
zoom = 10; samples=10;
clear ns zs;
[ns, zs] = meshgrid(25*(2.^(0:samples))',0:zoom);

% Define function and it's minimum
f2 = @(x) cos(x) + 2*cos(2*x) + 5*cos(4.5*x) + 7*cos(9*x);
f2_min = mcmin(f2,2,7,10^6);
% mczoom for every combination of zoom and sample size
m = arrayfun(@(n,z)mczoom(f2,2,7,n,z),ns,zs);

figure(3);
plot3(ns,zs,abs(f2_min-m))
title('f_2 adaptive zoom MC');
xlabel('sample size');
ylabel('zoom level');
zlabel('absolute error');
set(gca, 'XScale', 'log', 'YScale', 'linear', 'ZScale', 'log');

% Define function and it's minimum
f3 = @(x) -sech(10*(x-2)).^2 - sech(100*(x-4)).^2 - sech(1000*(x-6)).^2;
f3_min = mcmin(f3,10^6);
% mczoom for every combination of zoom and sample size
m = arrayfun(@(n,z)mczoom(f3,n,z),ns,zs);

figure(4);
plot3(ns,zs,abs(f3_min-m));
title('f_3 adaptive zoom MC');
xlabel('sample size');
ylabel('zoom level');
zlabel('absolute error');
set(gca, 'XScale', 'log', 'YScale', 'linear', 'ZScale', 'log');

%%
% Inspecting the plots shows that for $f_2$ the benefit of using the
% adaptive zoom is difficult to asses, but for $f_3$ there is noticeable
% benefit.  This likely arises from the fact that $f_3$ has a minimum near
% it's boundaries, and the adaptive zoom method essentially performs like a
% bisection search for the minimum, closing in on $x=1$.

%% Random Walks & Laplace's Equation
% Using random walks, we can average random solutions to converge on the
% real solution to Laplace's equation.  First let's examine a few random
% walks on the domain $[0,1]x[0,1]$ with a grid size of $s=0.1$ starting at
% random interior nodes.

% Generate random start positions on the grid
n = 4; % Number of random walks
I = randi([1 9], n, 2);

% Perform random walk for each pair of start conditions
%
% Use integers and then transform later to prevent issues with numerical
% precision and the ordinal operators used in the stop function of randwalk
W = arrayfun(@(x,y) randwalk([x y],[0 10; 0 10])./10, I(:,1), I(:,2), ...
    'UniformOutput',false);

% Plot all random walks
figure(5)
hold on;
arrayfun(@(i)plot(W{i}(:,1),W{i}(:,2),'.-'),1:size(I,1))
hold off;
legend(arrayfun(@(x,y) sprintf('(%g,%g)',x,y), I(:,1)./10, I(:,2)./10, ...
    'UniformOutput',false),'Location','northeastoutside')
title(sprintf('%i Random Walks', size(I,1)))
xlim([0,1]); ylim([0,1]);

%% Varying the Number of Random Walks
% We can approximate the solution to Laplace's equation with the random
% walks, using the solution $u = e^ycos(x)$ to calculate the error for our
% approximations.

n = (1:10).*10;

u = @(x) exp(x(1)).*cos(x(2));
last = @(W) u(W(end,:));

d = 1/10; % Define a resolution
[X, Y] = meshgrid(0+d:d:1-d, 0+d:d:1-d); % Grid interior nodes
E = exp(X).*cos(Y); % exact solution for each interior node

M = zeros([size(X) numel(n)]);
for i=1:numel(n)
    L = zeros([size(X) n(i)]);
    for j=1:n(i)
        L(:,:,j) = arrayfun(...
            @(x,y) last( randwalk([x y], [0 1; 0 1], 0.1) ), ...
            X, Y);
    end
    M(:,:,i) = mean(L,3) - E;
end

%%
% We can plot the error over the interior nodes for each number of random
% walks $N$ and observe that the general trend is that the error decreases
% with $N$, and the $L_2$ norm of the error also decreases with increasing
% $N$.

upper = round(max(max(max(M))),1); % find and round upper error bound
ns = [10 20 50 100]; % Define the set of N values to plot, no more than 4

figure(6);
for p=1:4
    subplot(2,2,p), surf(X,Y,abs(M(:,:,n==ns(p))));
    title(sprintf("N=%i",ns(p)));
    zlim([0 upper]);
end

figure(7);
semilogy(n, arrayfun(@(i)norm(M(:,:,i))./n(i),1:numel(n)));
title('L_2 norm vs N Walks');
xlabel('N_{walks}');
ylabel('L_2 norm of \epsilon_{abs}');
