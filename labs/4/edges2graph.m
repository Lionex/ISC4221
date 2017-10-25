function [ G ] = edges2graph( E, directed )
%EDGES2GRAPH Builds an adjacency matrix representation of a graph
%
%   Will build a directed or undirected graph, but not a weighted graph.
%   Requiers an Edge matrix E, where each element is an integer and each
%   node is represented by an integer.  Ideally, to keep the graph as small
%   as possible, the node IDs for n nodes should be 1:n.
%
%   The size of the adjacency matrix is SxS where S is the largest id.
%
%   EDGES2GRAPH(E) where E will produce a logical matrix where element i,j
%   and j,1 are true if edges i and j in the graph are connected; in other
%   words, the matrix is symmetric.
%
%   EDGES2GRAPH(E,'directed') will produce a directed graph, where only
%   element i,j is true for each connection from i -> j
%
%   Examples:
%
%   To get the degree of each node we can simply calculate the sum of each
%   column or row.  For undirected graphs they are equivalent, but for
%   directed graphs the column sum is the number of incoming connections
%   and the row sum is the number of outgoing connections.
%
%       G = EDGES2GRAPH(E);
%       degree = sum(G);
%
%       G = EDGES2GRAPH(E,'directed');
%       deg_i = sum(G); % degree of incoming connections for each node
%       deg_o = sum(G,2); % degree of outgoing connections for each node
%
%   Assuming no nodes are connected to themselves, you can easily calculate
%   the number of edges in the graph.
%
%       G = EDGES2GRAPH(E);
%       numel(G(1==G))/2 % divide by two for an undirected graph only

% Handle variadic arguments
if size(E,2) ~= 2, E = fliplr(E'); end
if size(E,2) ~= 2, error('E must be 2xN or Nx2'); end
if ~all(all(E==fix(E)))
    warning('E is not integral, calling fix(E)');
    E = fix(E);
end
if ~all(all(E > 0)); error('E must have all positive, non-zero ids'); end
if nargin < 2, directed = 'undirected'; end
directed = strcmp('directed',directed);

% Preallocate empty adjacency matrix G
G = zeros(max(max(E)));

% To make the edges undirected, reverse every connection
if ~directed, E = [E ; fliplr(E)]; end

% Calculate the linear indicies of G which correspond to each edge
I = sub2ind(size(G), E(:,1), E(:,2));

% Place a 1 at every matrix elelment i,j of G for each edge between nodes i
% and j to build an adjacency matrix representaion of the graph.
G(I) = 1;

end

