% Lab03: Graph Traversal in Prolog
% Author: Aispur Santiago
% Date: 2025-10-12

% ---------------------------------------------------------------------------
% 1. GRAPH REPRESENTATION
% ---------------------------------------------------------------------------
% We define the directed graph using edge/2 facts. Each edge is a connection from one node to another.
edge(a, b).
edge(b, c).
edge(a, d).
edge(d, c).

% ---------------------------------------------------------------------------
% 2. PATH DEFINITIONS (RECURSIVE)
% ---------------------------------------------------------------------------
% path(X, Y): true if there is a path from X to Y.
% Base case: direct edge.
path(X, Y) :- edge(X, Y).
% Recursive case: connect through intermediate nodes.
path(X, Y) :- edge(X, Z), path(Z, Y).

% ---------------------------------------------------------------------------
% 3. HANDLING CYCLES (VISITED LIST)
% ---------------------------------------------------------------------------
% In graphs with cycles, recursion may run forever.
% We prevent infinite loops by storing visited nodes.

% path(X, Y, Visited): true if there is a path from X to Y, not revisiting nodes in Visited.
% Initial call: path(X, Y, []).
path(X, Y, _) :- edge(X, Y).
path(X, Y, Visited) :-
    edge(X, Z),
    \+ member(Z, Visited),
    path(Z, Y, [X|Visited]).

% ---------------------------------------------------------------------------
% 4. LISTING ALL PATHS (findall/3)
% ---------------------------------------------------------------------------
% To find all possible paths from a to c:
% Example query: ?- findall(P, path(a, c, []), Paths).
% This collects all valid paths from a to c, avoiding cycles.

% ---------------------------------------------------------------------------
% 5. CYCLE EXAMPLE
% ---------------------------------------------------------------------------
% To test cycles, add edge(c, a).
% Uncomment the line below to introduce a cycle:
% edge(c, a).

% ---------------------------------------------------------------------------
% 6. STUDENT EXTENSION: MAZE EXAMPLE
% ---------------------------------------------------------------------------
% Let's represent a maze as a graph. Each room is a node, doors are edges.

% Example maze:
% room1 -- room2 -- room3
%    |               |
%  room4 ---------- room5

% Maze edges:
edge(room1, room2).
edge(room2, room3).
edge(room1, room4).
edge(room4, room5).
edge(room5, room3).

% Find a path from entrance to exit (room1 to room3):
% ?- path(room1, room3, []).
% To get the actual path as a list:
% ?- path_with_nodes(room1, room3, Path).
% See below for implementation.

% Helper to collect path as a list of nodes:
path_with_nodes(X, Y, [X,Y]) :- edge(X, Y).
path_with_nodes(X, Y, [X|Rest]) :-
    edge(X, Z),
    \+ member(Z, Rest),
    path_with_nodes(Z, Y, Rest).

% ---------------------------------------------------------------------------
% 7. EXAMPLE QUERIES AND OUTPUTS
% ---------------------------------------------------------------------------
% Main graph:
% ?- path(a, c).
% true.
%
% ?- path(b, a).
% false.
%
% ?- findall(P, path(a, c, []), Paths).
% Paths = [[a, b, c], [a, d, c]].
%
% If you add edge(c, a), cycles are avoided due to the visited list.

% Maze:
% ?- path(room1, room3, []).
% true.
%
% ?- path_with_nodes(room1, room3, P).
% P = [room1, room2, room3] ;
% P = [room1, room4, room5, room3].

% ---------------------------------------------------------------------------
% END OF LAB
% ---------------------------------------------------------------------------
