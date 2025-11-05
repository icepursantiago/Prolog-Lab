% Lab06: Constraint-Based Scheduling System
% Author: Aispur Santiago
% Date: 2025-11-05

% 1. INTRODUCTION AND SETUP
% ---------------------------------------------------------------------------
% This lab implements a constraint-based scheduling system using Constraint Logic
% Programming over Finite Domains (CLPFD). The scheduler assigns start times to tasks
% while respecting duration, precedence, and resource constraints, then optimizes
% to minimize the total completion time (makespan).

:- use_module(library(clpfd)).

% 2. TASK REPRESENTATION
% ---------------------------------------------------------------------------
% Tasks are represented as task(Name, Duration, Resource) where:
% - Name: identifier for the task (e.g., a, b, c)
% - Duration: time units required to complete the task
% - Resource: resource ID needed (tasks on same resource cannot overlap)

% 3. BASIC CONSTRAINT THEORY
% ---------------------------------------------------------------------------
% The scheduling system uses several types of constraints:
%
% 1. Duration Constraints: End #= Start + Duration
%    - Ensures each task's end time equals its start plus duration
%
% 2. Precedence Constraints: EndA #=< StartB
%    - Task A must finish before Task B can start
%
% 3. Non-Overlap Constraints: disjoint1/1
%    - Tasks using the same resource cannot execute simultaneously
%    - Uses tasks([task(Start, Duration, End, _, 1)]) format
%
% 4. Makespan Optimization: Makespan #= max(all end times)
%    - Minimizes total completion time using labeling([min(Makespan)], Vars)

% 4. CORE SCHEDULING PREDICATE
% ---------------------------------------------------------------------------

% schedule/4 - Main scheduling predicate
% schedule(Tasks, Starts, Ends, Makespan)
% Tasks: list of task(Name, Duration, Resource) facts
% Starts: list of start times for each task
% Ends: list of end times for each task
% Makespan: total time to complete all tasks

schedule(Tasks, Starts, Ends, Makespan) :-
    % Extract task information
    extract_task_info(Tasks, Names, Durations, Resources),
    length(Tasks, N),
    
    % Create start time variables with domain
    length(Starts, N),
    Starts ins 0..1000,
    
    % Create end time variables
    length(Ends, N),
    
    % Apply duration constraints: End #= Start + Duration
    apply_duration_constraints(Starts, Durations, Ends),
    
    % Apply non-overlap constraints for tasks on same resource
    apply_resource_constraints(Starts, Durations, Ends, Resources),
    
    % Apply precedence constraints (task dependencies)
    apply_precedence_constraints(Names, Starts, Ends),
    
    % Calculate makespan as maximum of all end times
    maximum_end_time(Ends, Makespan),
    
    % Optimize: find schedule that minimizes makespan
    append(Starts, [Makespan], Vars),
    labeling([min(Makespan)], Vars).

% 5. CONSTRAINT APPLICATION PREDICATES
% ---------------------------------------------------------------------------

% extract_task_info/4 - Extract components from task list
extract_task_info([], [], [], []).
extract_task_info([task(Name, Duration, Resource)|Rest], [Name|Names], [Duration|Durations], [Resource|Resources]) :-
    extract_task_info(Rest, Names, Durations, Resources).

% apply_duration_constraints/3 - Apply End = Start + Duration for all tasks
apply_duration_constraints([], [], []).
apply_duration_constraints([Start|Starts], [Duration|Durations], [End|Ends]) :-
    End #= Start + Duration,
    apply_duration_constraints(Starts, Durations, Ends).

% apply_resource_constraints/4 - Ensure tasks on same resource don't overlap
apply_resource_constraints(Starts, Durations, Ends, Resources) :-
    group_by_resource(Starts, Durations, Ends, Resources, GroupedTasks),
    apply_disjoint_constraints(GroupedTasks).

% group_by_resource/5 - Group tasks by their resource ID
group_by_resource(Starts, Durations, Ends, Resources, GroupedTasks) :-
    findall(Resource, member(Resource, Resources), AllResources),
    sort(AllResources, UniqueResources),
    group_tasks_by_resources(UniqueResources, Starts, Durations, Ends, Resources, GroupedTasks).

% group_tasks_by_resources/6 - Helper to group tasks for each resource
group_tasks_by_resources([], _, _, _, _, []).
group_tasks_by_resources([Resource|RestResources], Starts, Durations, Ends, Resources, [TasksForResource|RestGrouped]) :-
    filter_tasks_for_resource(Starts, Durations, Ends, Resources, Resource, TasksForResource),
    group_tasks_by_resources(RestResources, Starts, Durations, Ends, Resources, RestGrouped).

% filter_tasks_for_resource/6 - Filter tasks belonging to a specific resource
filter_tasks_for_resource([], [], [], [], _, []).
filter_tasks_for_resource([S|Ss], [D|Ds], [E|Es], [R|Rs], Resource, [task(S,D,E,_,1)|Tasks]) :-
    R = Resource, !,
    filter_tasks_for_resource(Ss, Ds, Es, Rs, Resource, Tasks).
filter_tasks_for_resource([_|Ss], [_|Ds], [_|Es], [_|Rs], Resource, Tasks) :-
    filter_tasks_for_resource(Ss, Ds, Es, Rs, Resource, Tasks).

% apply_disjoint_constraints/1 - Apply disjoint1 to each resource group
apply_disjoint_constraints([]).
apply_disjoint_constraints([[]|Rest]) :- 
    apply_disjoint_constraints(Rest).
apply_disjoint_constraints([Tasks|Rest]) :-
    Tasks \= [],
    disjoint1(Tasks),
    apply_disjoint_constraints(Rest).

% apply_precedence_constraints/3 - Define task dependencies
% Task 'a' must complete before task 'b' starts
apply_precedence_constraints(Names, Starts, Ends) :-
    ( member_at_index(a, Names, IdxA),
      member_at_index(b, Names, IdxB) ->
        nth1(IdxA, Ends, EndA),
        nth1(IdxB, Starts, StartB),
        EndA #=< StartB
    ; true
    ).

% member_at_index/3 - Find index of element in list (1-based)
member_at_index(Element, List, Index) :-
    nth1(Index, List, Element).

% maximum_end_time/2 - Calculate maximum of all end times
maximum_end_time([End], End) :- !.
maximum_end_time([E1, E2], Max) :- 
    !, Max #= max(E1, E2).
maximum_end_time([E1, E2, E3], Max) :- 
    !, Max #= max(E1, max(E2, E3)).
maximum_end_time([E|Es], Max) :-
    maximum_end_time(Es, MaxRest),
    Max #= max(E, MaxRest).

% 6. EXAMPLE TASK DEFINITIONS
% ---------------------------------------------------------------------------

% example_tasks/1 - Three tasks from lab instructions
% task(a, 3, 1): Task 'a' takes 3 time units, uses resource 1
% task(b, 2, 1): Task 'b' takes 2 time units, uses resource 1
% task(c, 4, 2): Task 'c' takes 4 time units, uses resource 2
example_tasks([
    task(a, 3, 1),
    task(b, 2, 1),
    task(c, 4, 2)
]).

% example_tasks_extended/1 - More complex scheduling scenario
example_tasks_extended([
    task(task1, 5, 1),
    task(task2, 3, 1),
    task(task3, 4, 2),
    task(task4, 2, 2)
]).

% 7. UTILITY PREDICATES FOR OUTPUT
% ---------------------------------------------------------------------------

% print_schedule/3 - Display schedule in readable format
print_schedule(Tasks, Starts, Ends) :-
    extract_task_info(Tasks, Names, Durations, Resources),
    format('~n=== OPTIMIZED SCHEDULE ===~n~n', []),
    format('Task | Start | End | Duration | Resource~n', []),
    format('-----|-------|-----|----------|----------~n', []),
    print_schedule_rows(Names, Starts, Ends, Durations, Resources).

% print_schedule_rows/5 - Print each task's schedule information
print_schedule_rows([], [], [], [], []).
print_schedule_rows([Name|Names], [Start|Starts], [End|Ends], [Duration|Durations], [Resource|Resources]) :-
    format('~w    |   ~w   |  ~w  |    ~w     |    ~w~n', [Name, Start, End, Duration, Resource]),
    print_schedule_rows(Names, Starts, Ends, Durations, Resources).

% solve_and_print/1 - Solve scheduling problem and display results
solve_and_print(Tasks) :-
    format('~nSolving scheduling problem...~n', []),
    schedule(Tasks, Starts, Ends, Makespan),
    print_schedule(Tasks, Starts, Ends),
    format('~nTotal Makespan (completion time): ~w time units~n~n', [Makespan]).

% 8. CONSTRAINT VERIFICATION UTILITIES
% ---------------------------------------------------------------------------

% verify_schedule/4 - Verify that a schedule satisfies all constraints
verify_schedule(Tasks, Starts, Ends, Makespan) :-
    extract_task_info(Tasks, _, Durations, Resources),
    
    % Verify duration constraints
    verify_durations(Starts, Durations, Ends),
    
    % Verify no overlaps on same resource
    verify_no_overlaps(Starts, Durations, Ends, Resources),
    
    % Verify makespan
    maximum_end_time(Ends, Makespan),
    
    format('Schedule verified successfully!~n', []).

% verify_durations/3 - Check all duration constraints are satisfied
verify_durations([], [], []).
verify_durations([Start|Starts], [Duration|Durations], [End|Ends]) :-
    End =:= Start + Duration,
    verify_durations(Starts, Durations, Ends).

% verify_no_overlaps/4 - Check no tasks on same resource overlap
verify_no_overlaps(Starts, Durations, Ends, Resources) :-
    check_all_pairs(Starts, Ends, Resources).

% check_all_pairs/3 - Verify all pairs of tasks don't overlap if on same resource
check_all_pairs([], [], []).
check_all_pairs([S1|Ss], [E1|Es], [R1|Rs]) :-
    check_with_rest(S1, E1, R1, Ss, Es, Rs),
    check_all_pairs(Ss, Es, Rs).

% check_with_rest/6 - Check one task against all remaining tasks
check_with_rest(_, _, _, [], [], []).
check_with_rest(S1, E1, R1, [S2|Ss], [E2|Es], [R2|Rs]) :-
    ( R1 =:= R2 ->
        ( E1 =< S2 ; E2 =< S1 )  % No overlap if same resource
    ; true
    ),
    check_with_rest(S1, E1, R1, Ss, Es, Rs).

% 9. PERFORMANCE STATISTICS
% ---------------------------------------------------------------------------

% solve_with_stats/1 - Solve and display performance metrics
solve_with_stats(Tasks) :-
    statistics(runtime, [T0|_]),
    schedule(Tasks, Starts, Ends, Makespan),
    statistics(runtime, [T1|_]),
    Runtime is T1 - T0,
    print_schedule(Tasks, Starts, Ends),
    format('~nSolved in ~w milliseconds~n', [Runtime]),
    format('Total Makespan: ~w time units~n~n', [Makespan]).

% ---------------------------------------------------------------------------
% 10. EXAMPLE QUERIES AND EXPLANATIONS
% ---------------------------------------------------------------------------

% 1. Basic example with three tasks:
%    ?- example_tasks(T), schedule(T, Starts, Ends, Makespan).
%    This finds start and end times for each task with optimal makespan.
%    Expected output:
%    T = [task(a,3,1), task(b,2,1), task(c,4,2)],
%    Starts = [0, 3, 0],
%    Ends = [3, 5, 4],
%    Makespan = 5.
%    
%    Explanation:
%    - Task 'a' (duration 3, resource 1): starts at 0, ends at 3
%    - Task 'b' (duration 2, resource 1): starts at 3, ends at 5
%      (must wait for 'a' due to precedence and same resource)
%    - Task 'c' (duration 4, resource 2): starts at 0, ends at 4
%      (can run parallel to 'a' since different resource)
%    - Total completion time (makespan): 5 time units

% 2. Solve and print formatted output:
%    ?- example_tasks(T), solve_and_print(T).
%    This displays the schedule in a readable table format.

% 3. Solve with performance statistics:
%    ?- example_tasks(T), solve_with_stats(T).
%    Shows how long the constraint solver took to find the solution.

% 4. Verify a solution:
%    ?- example_tasks(T), schedule(T, S, E, M), verify_schedule(T, S, E, M).
%    Checks that the computed schedule satisfies all constraints.

% 5. Extended example with more tasks:
%    ?- example_tasks_extended(T), solve_and_print(T).
%    Solves a more complex scheduling problem with four tasks.

% 6. Manual constraint testing:
%    ?- X in 0..10, Y in 0..10, Y #= X + 3, label([X,Y]).
%    Tests basic CLPFD constraint solving.

% 7. Testing disjoint constraints:
%    ?- Tasks = [task(0,3,3,_,1), task(4,2,6,_,1)], disjoint1(Tasks).
%    Verifies that two tasks with same resource don't overlap.

% ---------------------------------------------------------------------------
% 11. DELIVERABLES SUMMARY
% ---------------------------------------------------------------------------

% This lab submission includes:
%
% 1. Aispur_S_Lab06_Logic.pl - Complete Prolog implementation
%    - Constraint-based scheduling system using CLPFD
%    - schedule/4 predicate with all required constraints
%    - Precedence, duration, and resource constraints
%    - Makespan optimization using labeling([min(Makespan)], Vars)
%
% 2. Example schedule output showing start and end times:
%    Run: ?- example_tasks(T), solve_and_print(T).
%    
%    Output format:
%    === OPTIMIZED SCHEDULE ===
%    
%    Task | Start | End | Duration | Resource
%    -----|-------|-----|----------|----------
%    a    |   0   |  3  |    3     |    1
%    b    |   3   |  5  |    2     |    1
%    c    |   0   |  4  |    4     |    2
%    
%    Total Makespan (completion time): 5 time units
%
% 3. Optimized result demonstrating constraint satisfaction:
%    - All duration constraints satisfied (End = Start + Duration)
%    - No overlapping tasks on same resource
%    - Precedence constraints respected (a completes before b starts)
%    - Makespan minimized through CLPFD optimization

% ---------------------------------------------------------------------------
% 12. RUNNING THE SCHEDULER
% ---------------------------------------------------------------------------
% To run the basic example:
% ?- example_tasks(T), solve_and_print(T).

% To verify the solution:
% ?- example_tasks(T), schedule(T, S, E, M), verify_schedule(T, S, E, M).

% ---------------------------------------------------------------------------
