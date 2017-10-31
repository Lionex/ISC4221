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
% We can calculate the shortest path from a graph using breadth-first
% search to produce the path.

clear E G;

% Produce graph
G = edges2graph(read('paths_edges.txt'));

% Test for the existence of paths between nodes
p1 = bfs(G,7,8);
if numel(p1) > 0
    fprintf('A path exists connecting node G to node H:\n');
    fprintf(' %i,', char(p1+64));
    fprintf('.\n');
else
    disp('No path exists connecting node G to node H.');
end

% Test for the existence of paths between nodes
p2 = bfs(G,7,9);
if numel(p2) > 0
    fprintf('A path exists connecting node G to node F:\n');
    fprintf('%c(%i) ', [char(p2+64); p2]);
    fprintf('\n');
else
    disp('No path exists connecting node G to node F.');
end

%% Problem 3
%
% We can brute-force calculate the shortest path in the travelling
% saleseman problem by finding the cost of every permutation in the order
% of cities to find the set of shortest paths, or the shortest circular
% path through the graph.

clear G;

E = read('tsp_edges.txt');
E(:,3) = fscanf(fopen('tsp_edge_weights.txt'), '%g')';

W = edges2weighted(E);

P = perms(1:size(W,1)); % Find all possible routes
P = [P P(:,1)]; % Add return trips to factor return cost

% Convert all paths to linear indecies into the graph W
edge2index = @(i) sub2ind(size(W),P(:,i),P(:,i+1));
I = cell2mat(arrayfun(edge2index,1:size(W,1), 'UniformOutput',false));

% Calculate the cost of every path using the linear indecies
C = sum(W(I),2);
M = min(C);

% Determine the solution set using logical indexing against minimum cost
S = P(C==M,1:end-1); % Ommit return trip from solutions

% Print results
fprintf('The solution set of cost %i includes the paths:\n',M);

% Convert solution to an easily printable representation
T = [reshape(char(S+64)',1,numel(S)); reshape(char(S+48)',1,numel(S))];
% Generate a formatter on the fly with the correct number of columns
formatter = cell2mat(arrayfun(@(x)'%c(%c) ',1:size(W,1), ...
    'UniformOutput',false));
% Output results with a new line at the end of each row
fprintf([formatter '\n'],T);

%% Problem 4
