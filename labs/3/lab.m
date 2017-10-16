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
f = @(x) abs(cos(pi.*x));
f2 = @(x) cos(x) + 2*cos(2*x) + 5*cos(4.5*x) + 7*cos(9*x);
f3 = @(x) -sech(10*(x-2)).^2 - sech(100*(x-4)).^2 - sech(1000*(x-6)).^2;

figure(1);
xs = linspace(0,1,1000);
ys = f(xs);
subplot(3,1,1), plot(xs,ys,'r');
title('Functions over their domains');
legend('f_1');

xs = linspace(2,7,1000);
ys = f2(xs);
subplot(3,1,2), plot(xs,ys,'b');
legend('f_2');

xs = linspace(0,1,1000);
ys = f3(xs);
subplot(3,1,3), plot(xs,ys,'m');
legend('f_3');

%%
% From the plots we can visually estimate the global minima:
%
% $$
% \begin{tabular}{c|c}
%   function & $x_{min}$ \\
%   \hline
%   $f_1$ & $0.5$ \\
%   $f_2$ & $4.6$ \\
%   $f_3$ & $1$   \\
% \end{tabular}
% $$
%%
% Using a simple implementation of the Monte Carlo optimization sampling
% algorithm, we can test our values on the $abs(cos(\pi x))$, where we know
% analytically that the minimum is $0.5$.

runs = 10; % determine number of runs to perform

f = @(x) abs(cos(pi.*x)); % Define function to test minimization on
n = 25*(2.^(0:6))'; % create a range of sample sizes
m = arrayfun(@(n)mcmin(f,n),repmat(n,1,runs)); % perform mcmin on n samples

avgerr = mean(abs(0.5-m),2);
avg = mean(m,2);

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
