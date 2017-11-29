function [ G, V ] = lloyds( G, s, tol, D )
%LLOYDS produce a centroidal voronoi tesselation from generating points
%
%   LLOYDS(G,s) will cluster the data matrix D from the number of clusters
%   determined by the centroids C where:
%       - Each column of G represents an attribute and each row a generator
%       - s is the number of sample points per generator
%   LLOYDS(G,s,tol) will terminate when the change in centroids between
%   iterations is less than the tolerance.
%   LLOYDS(G,s,tol,D) is scalar will stop the walk when it reaches
%   the boundaries of a hypercube with side-length 2*D centered on the
%   origin.
%   LLOYDS(G,s,tol,D) where D is a matrix which defines the bounding
%   hyper-rectangle such that each row is the upper and lower bound of each
%   dimension of I.
%
%   [C, V] = LLOYDS(...)
%       - C is the of centroids for the centroidal voronoi tesselation
%       - V is variance in each dimension for each centroid
%
%   Examples
%   Plot the centroidal voronoi tesselation generated by lloyds with 100
%   samples for a set of random initial generators:
%       G = rand(16,2);
%       X = lloyds(G,100);
%       voronoi(X(:,1),X(:,2));
%
%   See also PLOT, ARRAYFUN, PAREN, KMEANS

% Handle variadic arguments
if nargin < 2, error('not enough input arguments'); end
if nargin < 3, tol=1e-5; end
if nargin < 4, D=repmat([0 1],size(G,1),1); end

% Define sample function from variadic logic
if isa(D,'function_handle')
    sample=D;  % Define stop as user defined function
elseif isscalar(D)
    D=repmat([-abs(D) abs(D)], size(G,1), 1); % Convert scalar D to matrix
end
if exist('sample','var') == 0 % Define stop function if not provided
    if size(D,1) ~= size(G,1)
        error('Mismatched constraint and generator dimensions');
    end

    D = repmat(D,s,1);
    sample = @(G,s) D(:,1)+(D(:,2)-D(:,1)) .* rand(size(G,1)*s,size(G,2));
end

X = sample(G,s);

% Simple utility function which simplifies the semantics of using arrayfun
% on non-uniform outputs which works as long as the outputs are vectors or
% matricies of the same size.
matrixfun = @(f,r)cell2mat(arrayfun(f,r,'UniformOutput',false));

% Utility function to evaluate if statements as an expression inline
if_=@(pred,tf)tf{2-pred}();

% Similarity functionn the change in centroids between
%   iterations is less than the tolerance.
%
% s = SIM(D,c) returns a column vector s of the scalar similarities between
% each row of D and the centroid c where:
%   - Each column of D represents an attirbute and each row a data point
%   - c is a row vector which represents a single centroid
%
% Default similarity function is the euclidian distance.
sim = @(D,c) sum((D-c).^2,2);

% Centroid function
%
% c = CF(D) returns a new centroid given the data which corrrespond to a
% single cluster.  The new centroid is at the mean.
cf = @(D) mean(D,1);

% Convergence criteria
%
% tf = CONVERGE(G,G_n) tells the algorithm when to stop; determines when we
% have sufficuently minimized our objective function.
converge = @(G,G_n) max(sqrt(sum((G-G_n).^2,2))) < tol;

% Index vector which keeps track of cluster membership
I = ones(size(X,1),1);

G_n=G;
for i_=1:3e3
    % Sample space once again
    X = sample(G,s);

    % Calculate distance matrix where each column represents distance to
    % each centroid, and each row represents the corresponding sampled
    % point in the sampled points
    S = matrixfun(@(i)sim(X,G(i,:)),1:size(G,1));

    % Find the closest generator points to the sampled points
    [~,I] = min(S,[],2);

    % Calculate new centroids using the objective function for finding the
    % new cluster centers
    G_n = matrixfun(@(i)cf(X(I==i,:))',1:size(G,1))';

    if converge(G,G_n), break; end

    % Keep the previous centroid if it is empty, otherwise update
    G=[G_n(~any(isnan(G_n),2),:); G(any(isnan(G_n),2),:)];
end

% Remove nans from result clusters and warns the user that one of the final
% clusters was truncated, and update the indecies to match the new clusters
if any(any(isnan(G_n))), warning('Empty final cluster'); end

% Number of categories of non-empty clusters
i = size(G(~any(isnan(G_n),2)),1);

% Calculate the variance, careful in cases where there is only one
% element in the cluster to ensure that the variance is reported as zero
V = matrixfun( ...
    @(i) if_( size(X(I==i,:),1) == 1, {   ...
        @()zeros(size(X,2),1), ... singlton cluster has zero variance
        @()var(X(I==i,:))' ... else get proper cluster variance
    }) ...
,1:i)'; % Run this for each cluster of more than 0 elements

end

