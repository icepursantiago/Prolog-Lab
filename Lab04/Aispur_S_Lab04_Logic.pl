% Lab04: Maze Path Reasoning in Prolog
% Author: Aispur Santiago
% Date: 2025-10-19

% ---------------------------------------------------------------------------
% 1. MAZE REPRESENTATION
% ---------------------------------------------------------------------------
% The maze is modeled as a graph. Rooms are nodes, doors are edges.
edge(entrance, a).
edge(a, b).
edge(a, c).
edge(b, exit).
edge(c, b).

% Some doors may be blocked:
blocked(a, c).  % Door is blocked from a to c.

% ---------------------------------------------------------------------------
% 2. REASONING RULES
% ---------------------------------------------------------------------------
% A move is allowed if there is an edge and it is not blocked.
can_move(X, Y) :- edge(X, Y), \+ blocked(X, Y).

% Reasoning predicate: explains if a path is open or blocked.
reason(X, Y, 'path is open') :- can_move(X, Y).
reason(X, Y, 'path is blocked') :- blocked(X, Y).
reason(_, exit, 'destination reached').  % Optional: explanation for exit

% ---------------------------------------------------------------------------
% 3. RECURSIVE TRAVERSAL WITH EXPLANATION
% ---------------------------------------------------------------------------
% move(X, Y, Visited, Path): recursively finds a path and prints reasoning.
move(X, Y, Visited, [Y|Visited]) :-
    can_move(X, Y),
    format('Moving from ~w to ~w.~n', [X, Y]).
move(X, Y, Visited, Path) :-
    can_move(X, Z),
    \+ member(Z, Visited),
    format('Exploring from ~w to ~w...~n', [X, Z]),
    move(Z, Y, [Z|Visited], Path).

% ---------------------------------------------------------------------------
% 4. MAIN PATH FINDER
% ---------------------------------------------------------------------------
% find_path(X, Y, Path): finds a path from X to Y, prints explanations.
find_path(X, Y, Path) :-
    move(X, Y, [X], RevPath),
    reverse(RevPath, Path).

% ---------------------------------------------------------------------------
% 5. EXAMPLE QUERIES AND COMMENTS
% ---------------------------------------------------------------------------
% Example query to try in Prolog:
% ?- find_path(entrance, exit, Path).
% Output:
% Moving from entrance to a.
% Exploring from a to b...
% Moving from b to exit.
% Path = [entrance, a, b, exit].

% Test individual reasoning:
% ?- can_move(a, b).
% true.
% ?- can_move(a, c).
% false.
% ?- reason(a, b, R).
% R = 'path is open'.
% ?- reason(a, c, R).
% R = 'path is blocked'.

% ---------------------------------------------------------------------------
% 6. REASONING SUMMARY
% ---------------------------------------------------------------------------
% The way the agent works is by checking the graph’s connections and any blocked paths to figure out which moves are actually possible. It doesn’t just jump from one node to another; instead, it uses special rules—like can_move/2 and reason/3—to see if a move makes sense and to understand why it’s allowed or not.

% As the agent tries to get from one place to another, it keeps calling the move/4 predicate over and over, kind of like retracing its steps, but it also remembers where it’s already been so it doesn’t end up going in circles. This visited list is super important for avoiding infinite loops.

% Every time the agent picks a move or rejects one, it actually explains that choice out loud (well, prints it using format/2), so you can follow its reasoning as it goes. You get to see the whole process, almost like you’re looking over the agent’s shoulder.

% At the end, everything comes together in the find_path/3 predicate. This is the main piece that shows the step-by-step trace of the agent’s thinking and the actual path it found through the graph.

% ---------------------------------------------------------------------------
% END OF LAB
% ---------------------------------------------------------------------------
