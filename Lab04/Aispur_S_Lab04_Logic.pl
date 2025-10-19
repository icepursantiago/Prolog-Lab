% Lab04: Maze Reasoning Agent in Prolog
% Author: Aispur Santiago
% Date: 2025-10-19

% ---------------------------------------------------------------------------
% 1. INTRODUCTION
% ---------------------------------------------------------------------------
% This lab brings together all the main Prolog concepts learned so far:
% facts, rules, recursion, lists, graph traversal, and reasoning.
% The goal is to build an intelligent agent that can navigate a maze,
% find a path, and explain its reasoning in human-readable form.

% ---------------------------------------------------------------------------
% 2. OBJECTIVES
% ---------------------------------------------------------------------------
% - Represent a maze as a graph.
% - Use reasoning rules to decide moves.
% - Apply recursion to find a path.
% - Generate explanations as the program runs.

% ---------------------------------------------------------------------------
% 3. BACKGROUND
% ---------------------------------------------------------------------------
% 3.1 Graphs in Prolog
% A maze is modeled as a graph where rooms are nodes and doors are edges.

% Example maze edges (rooms and connections):
edge(entrance, a).
edge(a, b).
edge(a, c).
edge(b, exit).
edge(c, b).

% Some paths may be blocked:
blocked(a, c). % Door is blocked from a to c.

% ---------------------------------------------------------------------------
% 4. REASONING PREDICATES
% ---------------------------------------------------------------------------
% Movement reasoning rules:
can_move(X, Y) :- edge(X, Y), \+ blocked(X, Y).

% Reasoning predicate to explain why a path is open or blocked:
reason(X, Y, 'path is open') :- can_move(X, Y).
reason(X, Y, 'path is blocked') :- blocked(X, Y).
% Optional extension: explain when the destination is reached
reason(_, exit, 'destination reached').

% ---------------------------------------------------------------------------
% 5. RECURSIVE TRAVERSAL WITH EXPLANATION
% ---------------------------------------------------------------------------
% move(X, Y, Visited, Path): recursively explores moves from X to Y, printing explanations.
move(X, Y, Visited, [Y|Visited]) :-
    can_move(X, Y),
    format('Moving from ~w to ~w.~n', [X, Y]).
move(X, Y, Visited, Path) :-
    can_move(X, Z),
    \+ member(Z, Visited),
    format('Exploring from ~w to ~w...~n', [X, Z]),
    move(Z, Y, [Z|Visited], Path).

% ---------------------------------------------------------------------------
% 6. MAIN PREDICATE
% ---------------------------------------------------------------------------
% find_path(X, Y, Path): finds a path from X to Y and prints reasoning at each step.
find_path(X, Y, Path) :-
    move(X, Y, [X], RevPath),
    reverse(RevPath, Path).

% ---------------------------------------------------------------------------
% 7. EXAMPLE EXECUTION
% ---------------------------------------------------------------------------
% Example query to run in the Prolog compiler:
% ?- find_path(entrance, exit, Path).
% Output:
% Moving from entrance to a.
% Exploring from a to b...
% Moving from b to exit.
% Path = [entrance, a, b, exit].

% You can test reasoning predicates separately, e.g.:
% ?- can_move(a, b).
% true.
% ?- can_move(a, c).
% false.
% ?- reason(a, b, R).
% R = 'path is open'.
% ?- reason(a, c, R).
% R = 'path is blocked'.

% ---------------------------------------------------------------------------
% 8. SUMMARY OF REASONING IMPLEMENTATION
% ---------------------------------------------------------------------------
% The agent uses graph facts (edges and blocked paths) to decide possible moves.
% Reasoning rules (can_move/2 and reason/3) determine if a move is possible and why.
% Recursive traversal (move/4) explores the graph, using a visited list to prevent loops.
% At each step, explanations are printed using format/2, showing the agent's decision process.
% The main predicate (find_path/3) ties everything together, providing a full trace and the path.

% ---------------------------------------------------------------------------
% END OF LAB
% ---------------------------------------------------------------------------
