%% Lab 5: Clustering
% Gwen Lofman
%%
%% Part 1: Clustering Data with K-Means
%
% Given data for forged and genuine bank records, we can cluster them and
% classify newly encountered bank records as forged or genuine by
% determining which cluster they would fall into from the sample, or
% training, data set.
%
% Here we apply k-means optimization to do just that, and determine if the
% bank record $\[214.9 130.2 130.3 9.2 9.8 140.1\]$ is genuine.

Forged = load('bank_forge.mat','-ASCII');
Genuine = load('bank_genuine.mat','-ASCII');

D = [Forged; Genuine];

I = [];
C = [];
V = inf;

for i_=1:10
    % Pick random initial clusters
    C_n = randn(2,size(D,2))*randi([1 5],1)+mean(D);

    % Perform K means and find the clusters which have the lowest variance
    [I_n,i,C_n,V_n] = kmeans(D,C_n,10e-2);

    % If we lose a cluster, skip
    if i < 2, continue; end

    % Update values if we have a lower cluster variance
    if sum(sum(V_n)) < sum(sum(V)), V = V_n; I = I_n; C = C_n; end
end

if D(I==1,:)==Forged, f=1; g=2; else, f=2; g=1; end

% Create a test record to identify if is a forgery or not
test = [214.9 130.2 130.3 9.2 9.8 140.1];

[~,i] = min(sqrt(sum((C-test).^2,2)));
fprintf('\n\nBank record '); fprintf('%g ',test);
if i==f, fprintf('is forged\n'); end
if i==g, fprintf('is genuine\n'); end

%%
% We can also attempt to cluster famous sample data sets, like the iris
% data set which describes flowers by their attributes such as sepal
% length, petal width, etc, to attempt to classify these flowers.
%
% Here we use the total cluster variance to determine the appropriate
% number of clusters, comparing total cluster variance to the number of
% clusters we have chosen.

clear
D = load('iris.mat','-ASCII');

for cs=2:6
    % Initialize values for the current number of clusters
    C{cs} = [];
    V{cs} = [inf];
    I{cs} = [];
    for i_=1:5
        % Pick random data points from D as initial clusters
        C_n = D(randi([1 size(D,1)],cs,1),:);

        % Perform K means and find the clusters which have the lowest variance
        [I_n,i,C_n,V_n] = kmeans(D,C_n,10e-2);

        % If we lose a cluster, skip
        if i < 2, continue; end

        % Update values if we have a lower cluster variance
        if sum(sum(V_n)) < sum(sum(V{cs}))
            V{cs} = V_n;
            I{cs} = I_n;
            C{cs} = C_n;
        end
    end
end

xs = 2:6;
vs = arrayfun(@(i)sum(sum(V{i})),xs);
plot(xs,vs);
title('Variance vs Number of Clusters');
xlabel('number of clusters');
ylabel('total variance');
