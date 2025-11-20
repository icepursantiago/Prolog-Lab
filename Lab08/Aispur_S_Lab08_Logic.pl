% Lab08: Map Coloring with Optimization - Finding Minimum Colors
% Author: Aispur Santiago
% Date: 2025-11-20

% ---------------------------------------------------------------------------
% 1. SETUP & MODULE LOADING
% ---------------------------------------------------------------------------
:- use_module(library(clpfd)).

% ---------------------------------------------------------------------------
% 2. AUSTRALIA ADJACENCY & REGION LISTS
% ---------------------------------------------------------------------------

regions_au([wa, nt, sa, q, nsw, v, t]).
edges_au([
    (wa,nt), (wa,sa), (nt,sa), (nt,q), (sa,q), (sa,nsw), (sa,v), (nsw,q), (nsw,v)
]).

% ---------------------------------------------------------------------------
% 3. SOUTH AMERICA REGIONS & EDGE LIST (adjacent pairs listed ONCE only)
% ---------------------------------------------------------------------------

regions_sa([co, ve, pe, ec, gy, sr, gf, br, uy, ar, chi, bo, py]).
edges_sa([
    (ve,co), (ve,gy), (ve,br), (gy,sr), (sr,gf), (sr,br),
    (co,pe), (co,ec), (co,br),
    (pe,ec), (pe,bo), (pe,br), (pe,chi),
    (ec,pe), (ec,co),
    (br,ve), (br,gy), (br,sr), (br,gf), (br,co), (br,pe), (br,bo), (br,uy), (br,ar), (br,py),
    (uy,ar), (uy,br),
    (ar,chi), (ar,py), (ar,bo), (ar,br),
    (chi,pe), (chi,bo), (chi,ar),
    (bo,py), (bo,ar), (bo,chi), (bo,pe), (bo,br),
    (py,ar), (py,bo), (py,br)
]).

% ---------------------------------------------------------------------------
% 4. COLOR NAMES (for pretty output)
% ---------------------------------------------------------------------------
color_name(1, red).    
color_name(2, green).  
color_name(3, blue).
color_name(4, yellow).
color_name(5, orange).
color_name(6, purple).

pretty_color_by_region([], []).
pretty_color_by_region([Region-Num|Rest], [Region-Col|T]) :-
    color_name(Num, Col),
    pretty_color_by_region(Rest, T).

print_pretty([]):- nl.
print_pretty([Region-Color|More]):-
    format('~w = ~w~n', [Region, Color]),
    print_pretty(More).

% ---------------------------------------------------------------------------
% 5. CORE MAP COLORING PREDICATE (from Lab 7)
% ---------------------------------------------------------------------------

color_map(Regions, Edges, K, Vars) :-
    % Create region-variable associations
    same_length(Regions, Vars),
    % Constrain variables to color domain
    Vars ins 1..K,
    % Apply adjacency constraints
    apply_edges(Regions, Vars, Edges),
    % Search for solution
    labeling([ffc], Vars).

% Helper: ensure Regions and Vars have same length
same_length([], []).
same_length([_|Rs], [_|Vs]) :- same_length(Rs, Vs).

% Helper: apply edge constraints
apply_edges(_, _, []).
apply_edges(Regions, Vars, [(A,B)|Rest]) :-
    nth1_member(A, Regions, Vars, CA),
    nth1_member(B, Regions, Vars, CB),
    CA #\= CB,
    apply_edges(Regions, Vars, Rest).

% Helper: find color variable for a region
nth1_member(Region, [Region|_], [Var|_], Var) :- !.
nth1_member(Region, [_|Rs], [_|Vs], Var) :-
    nth1_member(Region, Rs, Vs, Var).

% ---------------------------------------------------------------------------
% 6. MINIMUM COLORS OPTIMIZATION (NEW - Lab 8)
% ---------------------------------------------------------------------------

% Main optimization predicate
min_colors(Regions, Edges, MaxK, MinK, Vars) :-
    between(1, MaxK, K),
    color_map(Regions, Edges, K, Vars),
    MinK = K,
    !.  % Cut prevents searching for larger K values

% ---------------------------------------------------------------------------
% 7. CONVENIENCE PREDICATES FOR AUSTRALIA & SOUTH AMERICA
% ---------------------------------------------------------------------------

% Find minimum colors for Australia
min_colors_au(MaxK, MinK, Vars) :-
    regions_au(Rs), 
    edges_au(Es),
    min_colors(Rs, Es, MaxK, MinK, Vars).

% Find minimum colors for South America
min_colors_sa(MaxK, MinK, Vars) :-
    regions_sa(Rs), 
    edges_sa(Es),
    min_colors(Rs, Es, MaxK, MinK, Vars).

% ---------------------------------------------------------------------------
% 8. PRETTY PRINTING FOR MINIMAL COLORING
% ---------------------------------------------------------------------------

% Print minimal coloring for Australia
print_min_colors_au(MaxK) :-
    regions_au(Rs),
    edges_au(Es),
    min_colors(Rs, Es, MaxK, MinK, Vars),
    format('~n=== Australia Map Coloring ===%n'),
    format('Minimum colors needed: ~w~n~n', [MinK]),
    combine_regions_colors(Rs, Vars, Pairs),
    pretty_color_by_region(Pairs, Pretty),
    print_pretty(Pretty).

% Print minimal coloring for South America
print_min_colors_sa(MaxK) :-
    regions_sa(Rs),
    edges_sa(Es),
    min_colors(Rs, Es, MaxK, MinK, Vars),
    format('~n=== South America Map Coloring ===%n'),
    format('Minimum colors needed: ~w~n~n', [MinK]),
    combine_regions_colors(Rs, Vars, Pairs),
    pretty_color_by_region(Pairs, Pretty),
    print_pretty(Pretty).

% Helper: combine regions with their color values
combine_regions_colors([], [], []).
combine_regions_colors([R|Rs], [V|Vs], [R-V|Rest]) :-
    combine_regions_colors(Rs, Vs, Rest).

% ---------------------------------------------------------------------------
% 9. EXPERIMENTAL: DIFFERENT LABELING STRATEGIES
% ---------------------------------------------------------------------------

% Experiment with different labeling options
color_map_labeling(Regions, Edges, K, Vars, Strategy) :-
    same_length(Regions, Vars),
    Vars ins 1..K,
    apply_edges(Regions, Vars, Edges),
    labeling(Strategy, Vars).

% Test different strategies for Australia
test_labeling_au(K, Strategy) :-
    regions_au(Rs),
    edges_au(Es),
    format('~nTesting strategy: ~w~n', [Strategy]),
    statistics(runtime, [Start|_]),
    (color_map_labeling(Rs, Es, K, Vars, Strategy) ->
        statistics(runtime, [End|_]),
        Time is End - Start,
        format('SUCCESS in ~w ms~n', [Time]),
        combine_regions_colors(Rs, Vars, Pairs),
        pretty_color_by_region(Pairs, Pretty),
        print_pretty(Pretty)
    ;
        format('FAILED~n')
    ).

% ---------------------------------------------------------------------------
% 10. EXAMPLE QUERY USAGE:
% ---------------------------------------------------------------------------
% Task A - Find minimum colors:
% ?- min_colors_au(4, MinK, Vars).
% ?- min_colors_sa(6, MinK, Vars).
%
% Task B - Pretty printing:
% ?- print_min_colors_au(4).
% ?- print_min_colors_sa(6).
%
% Task C - Experiment with labeling:
% ?- test_labeling_au(3, []).
% ?- test_labeling_au(3, [ff]).
% ?- test_labeling_au(3, [ffc]).
% ?- test_labeling_au(3, [min]).
%
% Common labeling options:
% [] - leftmost variable first
% [ff] - first-fail: choose variable with smallest domain
% [ffc] - first-fail with constraint propagation
% [min] - select value with minimum
% [max] - select value with maximum

% ---------------------------------------------------------------------------
