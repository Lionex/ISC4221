function [ W, G ] = edges2weighted( E, directed )
%EDGES2WEIGHTED Builds an adjacency matrix of a weighted graph
%
%   Will build a directed or undirected weighted graph.
%
%   Requiers an Edge matrix E, where each row or column contains:
%   [ i j w ] where i and j are integer node ids, and w is the 'length' or
%   cost of the connection from i to j.  If i and j are not directly
%   connected, the value is Inf.
%
%   The size of the adjacency matrix is SxS where S is the largest id.
%
%   EDGES2WEIGHTED(E) where E will produce a matrix where element i,j
%   and j,1 contain the weight of the connection between i and j.
%
%   EDGES2WEIGHTED(E,'directed') will produce a directed graph, where only
%   element i,j contains the weight for each connection from i -> j
%
%   [W G] = EDGES2WEIGHTED(...) also produces the logical adjacency matrix
%   G which represents connections with true false instead of weights.
%
%   Examples:
%
%   To get the degree of each node we can simply calculate the sum of each
%   column or row.  For undirected graphs they are equivalent, but for
%   directed graphs the column sum is the number of incoming connections
%   and the row sum is the number of outgoing connections.
%
%       [W G] = EDGES2WEIGHTED(E);
%       degree = sum(G);
%
%       [W G] = EDGES2WEIGHTED(E,'directed');
%       deg_i = sum(G); % degree of incoming connections for each node
%       deg_o = sum(G,2); % degree of outgoing connections for each node
%
%   Assuming no nodes are connected to themselves, you can easily calculate
%   the number of edges in the graph.
%
%       [W G] = EDGES2WEIGHTED(E);
%       numel(G(1==G))/2 % divide by two for an undirected graph only
%
%   see also EDGES2GRAPH, NUMEL, SUM

% Handle variadic arguments
if size(E,2) ~= 3, E = fliplr(E'); end
if size(E,2) ~= 3, error('E must be 2xN or Nx2'); end
if ~all(all( E(:,1:2) == fix(E(:,1:2)) ))
    warning('E is not integral, calling fix(E)');
    E(:,1:2) = fix(E(:,1:2));
end
if nargin < 2, directed = 'undirected'; end
directed = strcmp('directed',directed);

% Preallocate empty adjacency matrix G and weight matrix W
G = zeros(max(max(E(:,1:2))));
W = zeros(size(G))+Inf;

% To make the edges undirected, reverse every connection
if ~directed, E = [E ; fliplr(E(:,1:2)) E(:,3)]; end

% Calculate the linear indicies of G which correspond to each edge
I = sub2ind(size(G), E(:,1), E(:,2));

% Place a 1 at every matrix elelment i,j of G for each edge between nodes i
% and j to build an adjacency matrix representaion of the graph.
G(I) = 1;

% Place the weight at each adjacency location
W(I) = E(:,3);

end
