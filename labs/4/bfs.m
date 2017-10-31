function [ p ] = bfs( G, S, E )
%BFS Calculates the minimum path between two nodes in a graph
%   BFS - Breadth-first search
%
%   Works on graphs with an adjacency matrix representation but will not
%   take into account non-uniform edge costs, only connectivity.
%
%   BFS(G, s, e) takes a graph G in adjacency matrix representation, start
%   node s, and goal node e.  s and e must be scalar.
%
%   P = BFS(...) will produce the node-ids for the nodes in the shortest
%   path.
%
%   See also EDGES2GRAPH, EDGES2WEIGHTED

% Check valid input format
if ~isscalar(S), error('start must be scalar'); end
if ~isscalar(E), error('goal must be scalar'); end
if size(G,1) ~= size(G,2), error('graph should be a square matrix'); end

% Ensure start and goal nodes are actually within the graph
if or(S > size(G,1), S < 1)
    error('Invalid start node %i', S);
end
if or(E > size(G,1), E < 1)
    error('Invalid goal node %i', E);
end

p = [];
q = s;
closed = [];
parent = containers.Map('KeyType', 'int32','ValueType','int32');

for i_=1:numel(G)*100
    if numel(q) < 1, break; end
    % If we've converged, unspool the trajectory from the parent map
    if q(1) == g
        p = g;
        c = p;
        % Follow parents until we reach the start node
        while c ~= s
            c = parent(c);
            p = [c p];
        end
    end

    % Iterate through neighbours of first element in the queue
    for n = 1:size(G,1)
        % Skip elements with no connections to the current node q(1)
        if ~(G(n,q(1)) > 0), continue; end
        % Skip elements already visited
        if any(closed==n), continue; end
        % Parent new elements to the current element
        if all(q ~= n)
            parent(n) = q(1);
            q=[q n];
        end
    end

    % Add explored nodes to the closed set of nodes to avoid
    % re-exploring nodes
    closed = [q(1) closed];
    q = q(2:end);
end

end
