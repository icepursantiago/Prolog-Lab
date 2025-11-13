% Lab07: Map Coloring with CLPFD - Australia & South America
% Author: Aispur Santiago
% Date: 2025-11-12

% ---------------------------------------------------------------------------
% 1. SETUP & MODULE LOADING
% ---------------------------------------------------------------------------
:- use_module(library(clpfd)).

% ---------------------------------------------------------------------------
% 2. AUSTRALIA ADJACENCY & REGION LISTS
% ---------------------------------------------------------------------------

regions_au([wa, nt, sa, q, nsw, v, t]).
edges_au([
    (wa,nt), (wa,sa), (nt,sa), (nt,q), (sa,q), (sa,nsw), (sa,v), (nsw,v)
]).

% ---------------------------------------------------------------------------
% 3. SOUTH AMERICA REGIONS & EDGE LIST (adjacent pairs listed ONCE only)
% ---------------------------------------------------------------------------

regions_sa([co, ve, pe, ec, gy, sr, gf, br, uy, ar, chi, bo, py]).
edges_sa([
    (ve,co), (ve,gy), (ve,br), (gy,sr), (sr,gf), 
    (co,pe), (co,ec),
    (pe,ec), (pe,bo), (pe,br), (pe,chi),
    (ec,co),
    (br,ve), (br,gy), (br,sr), (br,pe), (br,bo), (br,uy), (br,ar), (br,py),
    (uy,ar), (ar,py), (bo,chi), (bo,py)
]).

% ---------------------------------------------------------------------------
% 4. COLOR NAMES (for pretty output)
% ---------------------------------------------------------------------------
color_name(1, red).    color_name(2, green).  color_name(3, blue).
color_name(4, yellow).

pretty_color_by_region([], []).
pretty_color_by_region([Region-Num|Rest], [Region-Col|T]) :-
    color_name(Num, Col),
    pretty_color_by_region(Rest, T).

print_pretty([]):- nl.
print_pretty([Region-Color|More]):-
    format('~w = ~w~n', [Region, Color]),
    print_pretty(More).

% ---------------------------------------------------------------------------
% 5. GENERIC MAP COLORING PREDICATE
% ---------------------------------------------------------------------------

map_color(Regions, Edges, K) :-
    % Assign Prolog variable to each region
    make_region_vars(Regions, RegionColorList, Vars),
    Vars ins 1..K,
    % Add constraints for each edge (adjacent pair)
    maplist(diff_colors(RegionColorList), Edges),
    labeling([], Vars),
    % Pretty print result
    pretty_color_by_region(RegionColorList, Pretty),
    print_pretty(Pretty).

make_region_vars([], [], []).
make_region_vars([R|Rs], [R-C|Rest], [C|Vars]) :-
    make_region_vars(Rs, Rest, Vars).

diff_colors(Map, (A, B)) :-
    member(A-CA, Map), member(B-CB, Map),
    CA #\= CB.

% ---------------------------------------------------------------------------
% 6. ENTRY POINTS (for running as asked)
% ---------------------------------------------------------------------------

color_australia(K) :-
    regions_au(Regions), edges_au(Edges), map_color(Regions, Edges, K).

color_southamerica(K) :-
    regions_sa(Regions), edges_sa(Edges), map_color(Regions, Edges, K).

% ---------------------------------------------------------------------------
% 7. EXAMPLE QUERY USAGE:
% ---------------------------------------------------------------------------
% ?- color_australia(3).
% ?- color_australia(4).
% ?- color_southamerica(3).
% ?- color_southamerica(4).

% ---------------------------------------------------------------------------
% END OF LAB
% ---------------------------------------------------------------------------
