% Lab05: Constraint Logic Programming - Sudoku Solver
% Author: Aispur Santiago
% Date: 2025-10-30

% 1. INTRODUCTION AND SETUP
% ---------------------------------------------------------------------------
% This lab introduces Constraint Logic Programming over Finite Domains (CLPFD) in Prolog.
% CLPFD allows you to define numerical domains and constraints, making it powerful 
% for solving problems like scheduling, optimization, and puzzles such as Sudoku.

:- use_module(library(clpfd)).

% 2. SUDOKU PROBLEM DEFINITION
% ---------------------------------------------------------------------------
% Sudoku is a 9x9 puzzle divided into 3x3 blocks. The goal is to fill each cell 
% with a number between 1 and 9 so that:
% 1. Each row has unique numbers.
% 2. Each column has unique numbers.
% 3. Each 3x3 block has unique numbers.

% 3. SUDOKU REPRESENTATION IN PROLOG
% ---------------------------------------------------------------------------
% Represent the Sudoku board as a list of 9 lists (rows):
% Puzzle = [Row1, Row2, ..., Row9].
% Each Row is a list of 9 elements (variables or numbers).

% 4. BASIC CLPFD SYNTAX IMPLEMENTATION
% ---------------------------------------------------------------------------
% Domain assignment: Variables take values from 1 to 9
% Arithmetic constraints: Applied using CLPFD operators
% Inequality and distinctness constraints for uniqueness
% Labeling: Assigns concrete values to variables satisfying constraints

% 5. SUDOKU SOLVER IMPLEMENTATION
% ---------------------------------------------------------------------------

% sudoku/1 - Main predicate to solve Sudoku puzzles
sudoku(Rows) :-
    % Step 1: Define domain - each cell contains values 1-9
    append(Rows, Vars), 
    Vars ins 1..9,
    
    % Step 2: Apply row constraints - each row has unique numbers
    maplist(all_different, Rows),
    
    % Step 3: Apply column constraints - transpose and check uniqueness
    transpose(Rows, Columns), 
    maplist(all_different, Columns),
    
    % Step 4: Apply 3x3 block constraints
    blocks(Rows), 
    maplist(all_different, Rows).

% 6. DEFINING 3x3 BLOCKS
% ---------------------------------------------------------------------------

% blocks/1 - Extract all 3x3 blocks from the Sudoku grid
blocks([]).
blocks([A,B,C|Rest]) :-
    blocks3(A, B, C), 
    blocks(Rest).

% blocks3/3 - Process three rows to extract 3x3 blocks
blocks3([], [], []).
blocks3([A1,A2,A3|A], [B1,B2,B3|B], [C1,C2,C3|C]) :-
    all_different([A1,A2,A3,B1,B2,B3,C1,C2,C3]),
    blocks3(A, B, C).

% 7. EXAMPLE SUDOKU PUZZLES
% ---------------------------------------------------------------------------

% example_puzzle/1 - A partially filled Sudoku puzzle for testing
example_puzzle([
    [5,3,_,_,7,_,_,_,_],
    [6,_,_,1,9,5,_,_,_],
    [_,9,8,_,_,_,_,6,_],
    [8,_,_,_,6,_,_,_,3],
    [4,_,_,8,_,3,_,_,1],
    [7,_,_,_,2,_,_,_,6],
    [_,6,_,_,_,_,2,8,_],
    [_,_,_,4,1,9,_,_,5],
    [_,_,_,_,8,_,_,7,9]
]).

% harder_puzzle/1 - A more challenging Sudoku puzzle
harder_puzzle([
    [_,_,_,_,_,_,6,8,_],
    [_,_,_,_,_,3,_,_,_],
    [7,_,_,_,9,_,5,_,_],
    [5,7,_,_,_,_,_,_,_],
    [_,_,_,_,8,5,_,_,_],
    [_,_,_,_,_,_,_,1,1],
    [_,_,8,5,_,_,_,_,_],
    [_,_,_,_,_,_,_,_,_],
    [_,4,_,2,_,_,_,_,_]
]).

% 8. UTILITY PREDICATES
% ---------------------------------------------------------------------------

% solve_and_print/1 - Solve a puzzle and display the result in a formatted grid
solve_and_print(Puzzle) :-
    sudoku(Puzzle),
    maplist(writeln, Puzzle).

% validate_solution/1 - Check if a completed Sudoku solution is valid
validate_solution(Rows) :-
    % Check all rows have numbers 1-9
    maplist(check_complete_row, Rows),
    % Check all columns have numbers 1-9  
    transpose(Rows, Columns),
    maplist(check_complete_row, Columns),
    % Check all 3x3 blocks have numbers 1-9
    validate_blocks(Rows).

% check_complete_row/1 - Verify a row contains exactly numbers 1-9
check_complete_row(Row) :-
    sort(Row, [1,2,3,4,5,6,7,8,9]).

% validate_blocks/1 - Validate all 3x3 blocks in the solution
validate_blocks([]).
validate_blocks([A,B,C|Rest]) :-
    validate_blocks3(A, B, C),
    validate_blocks(Rest).

% validate_blocks3/3 - Validate 3x3 blocks from three rows
validate_blocks3([], [], []).
validate_blocks3([A1,A2,A3|A], [B1,B2,B3|B], [C1,C2,C3|C]) :-
    Block = [A1,A2,A3,B1,B2,B3,C1,C2,C3],
    check_complete_row(Block),
    validate_blocks3(A, B, C).

% 9. CONSTRAINT STATISTICS AND PERFORMANCE
% ---------------------------------------------------------------------------

% solve_with_stats/1 - Solve puzzle and show constraint statistics
solve_with_stats(Puzzle) :-
    statistics(runtime, [T0|_]),
    sudoku(Puzzle),
    statistics(runtime, [T1|_]),
    Runtime is T1 - T0,
    format('Sudoku solved in ~w milliseconds~n', [Runtime]),
    maplist(writeln, Puzzle).

% count_filled_cells/2 - Count how many cells are pre-filled in a puzzle
count_filled_cells(Puzzle, Count) :-
    append(Puzzle, Vars),
    include(nonvar, Vars, FilledVars),
    length(FilledVars, Count).

% ---------------------------------------------------------------------------
% 10. EXAMPLE QUERIES AND EXPLANATIONS
% ---------------------------------------------------------------------------

% 1. Solve the example puzzle:
%    ?- example_puzzle(P), sudoku(P), maplist(writeln, P).
%    This will solve and display the completed Sudoku grid.

% 2. Test with a harder puzzle:
%    ?- harder_puzzle(P), solve_with_stats(P).
%    Solves the harder puzzle and shows timing statistics.

% 3. Validate a solution:
%    ?- example_puzzle(P), sudoku(P), validate_solution(P).
%    Solves the puzzle and validates the solution is correct.

% 4. Count pre-filled cells:
%    ?- example_puzzle(P), count_filled_cells(P, Count).
%    Count = 29.
%    Shows how many cells were given in the original puzzle.

% 5. Simple constraint example (from lab instructions):
%    ?- X in 1..9, Y in 1..9, X + Y #= 10, label([X, Y]).
%    X = 1, Y = 9 ;
%    X = 2, Y = 8 ;
%    ... (and so on)

% ---------------------------------------------------------------------------
% 11. RUNNING THE SOLVER
% ---------------------------------------------------------------------------
% To run: ?- example_puzzle(P), sudoku(P), maplist(writeln, P).

% ---------------------------------------------------------------------------
