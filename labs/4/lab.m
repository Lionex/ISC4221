%% Lab 4: Algorithms for Graphs
% Gwen Lofman
%%
%% Problem 1
% edges2graph is a simple funcion which can produce a graph in adjacency
% matrix form from a list of its edges.
%
% It then becomes very easy to calculate the degree and edge count,
% assuming our graph is undirected.

% Simple lambda to read edges from a file
read = @(fname) fscanf(fopen(fname),'%g %g', [2 inf])';

% Produce graph
E = read('walther_edges.txt');
G = edges2graph(E);

% Print out degree for each node
fprintf('\n'); fprintf('N: %2i, deg %g\n', [1:size(G,2); sum(G)]);

% Print out edge count, veryfing that calculated result is equal to the
% number of edges we read in from the file
edgecount = numel(G(1==G))/2;
if size(E,1) ~= edgecount, error('Unexpected edge count'); end
fprintf('\nedge count %i\n', edgecount);

%% Problem 2



%% Problem 3


%% Problem 4
