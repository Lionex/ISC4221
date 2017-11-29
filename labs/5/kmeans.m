function [ I, i, C, V ] = kmeans( D, C, tol )
%KMEANS clustering on the input data set from provided centroids
%   KMEANS is a clustering algorithm which minimizes an objective function
%   derived from a measure of similarity between the data and the centroid
%   to determine clusters and identify
%
%   This KMEANS implementation uses the euclidian distance as the
%   similarity function and the mean as the objective function, and will
%   stop when the maximum distance between the current and previous set
%   of centroids is less than the given tolerance.
%
%   KMEANS(D,C) will cluster the data matrix D from the number of clusters
%   determined by the centroids C where:
%       - Each column of D represents an attribute and each row data point
%       - Each column of C represents an attribute and each row a centroid
%   KMEANS(D,C,tol) will terminate when the change in centroids between
%   iterations is less than the tolerance.
%
%   [I, i, C, V] = KMEANS(...)
%       - I is an index vector such that D(I==i,:) is the data in cluster i
%       - i is the number of clusters
%       - Each column of C represents an attribute and each row a centroid,
%       truncating any clusters that are empty at the final iteration
%       - Each column of V represents the variance of an atribute, each row
%       a centroid that corresponds to each row of C.  Note: if a centroid
%       represents an empty cluster, its variance is never calculated.
%
%   Examples
%   Plot all of the KMEANS clusters for a data set D with any number of 2D
%   data points and an arbitrary number of 2D centroids:
%       [I,i] = KMEANS(D,C);
%       hold on; arrayfun(@(n)plot(D(I==n,1),D(I==n,2),'o'),1:i); hold off;
%
%   See also PLOT, ARRAYFUN, PAREN

% Handle variadic arguments
if nargin < 2, error('not enough input arguments'); end
if nargin < 3, tol=1e-5; end

% Validate input set
if size(D,2) ~= size(C,2), error('Data and centroid size mismatch'); end

% Simple utility function which simplifies the semantics of using arrayfun
% on non-uniform outputs which works as long as the outputs are vectors or
% matricies of the same size.
matrixfun = @(f,r)cell2mat(arrayfun(f,r,'UniformOutput',false));

% Utility function to evaluate if statements as an expression inline
if_=@(pred,tf)tf{2-pred}();

% Similarity function
%
% s = SIM(D,c) returns a column vector s of the scalar similarities between
% each row of D and the centroid c where:
%   - Each column of D represents an attirbute and each row a data point
%   - c is a row vector which represents a single centroid
%
% Default similarity function is the euclidian distance.
sim = @(D,c) sum((D-c).^2,2);

% Objective function
%
% c = OF(D) returns a new centroid given the data which corrrespond to a
% single cluster.  The objective function is what K-menas minimizes, and
% should correspond to a given similarity measure.
%
% Default objective function is the mean.
of = @(D) mean(D,1);

% Convergence criteria
%
% tf = CONVERGE(C,C_n) tells the algorithm when to stop; determines when we
% have sufficuently minimized our objective function.
converge = @(C,C_n) max(sqrt(sum((C-C_n).^2,2))) < tol;

% Index vector which keeps track of cluster membership
I = ones(size(D,1),1);

C_n=C;
for i_=1:1e4
    % Calculate distance matrix where each column represents distance to
    % each centroid, and each row represents the corresponding data point
    % in the data matrix D
    S = matrixfun(@(i)sim(D,C(i,:)),1:size(C,1));

    % The indecies of the minimum distance represent the cluster membership
    [~,I] = min(S,[],2);

    % Calculate new centroids using the objective function for finding the
    % new cluster centers
    C_n = matrixfun(@(i)of(D(I==i,:))',1:size(C,1))';

    if converge(C,C_n), break; end

    % Keep the previous centroid if it is empty, otherwise update
    C=[C_n(~any(isnan(C_n),2),:); C(any(isnan(C_n),2),:)];
end

% Remove nans from result clusters and warns the user that one of the final
% clusters was truncated, and update the indecies to match the new clusters
if any(any(isnan(C_n))), warning('Empty final cluster'); end

% Number of categories of non-empty clusters
i = size(C(~any(isnan(C_n),2)),1);

% Calculate the variance, careful in cases where there is only one
% element in the cluster to ensure that the variance is reported as zero
V = matrixfun( ...
    @(i) if_( size(D(I==i,:),1) == 1, {   ...
        @()zeros(size(D,2),1), ... singlton cluster has zero variance
        @()var(D(I==i,:))' ... else get proper cluster variance
    }) ...
,1:i)'; % Run this for each cluster of more than 0 elements

end

