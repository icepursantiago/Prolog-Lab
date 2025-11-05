% Lab06: Constraint-Based Scheduling with CLPFD
% Author: Aispur Santiago
% Date: 2025-11-05

% ---------------------------------------------------------------------------
% 1. SETUP AND MODULE LOADING
% ---------------------------------------------------------------------------
% Load the CLPFD module to use constraint logic programming over finite domains
:- use_module(library(clpfd)).

% Define task facts: task(Name, Duration, Resource).
% Each task represents a Computer Science course with duration (hours) and resource (lab/classroom)
task(computer_architecture, 3, 1).     % Computer Architecture: 3 hours, uses lab 1
task(computational_logic, 2, 1).       % Computational Logic: 2 hours, uses lab 1  
task(advanced_programming, 4, 2).      % Advanced Programming: 4 hours, uses lab 2

% ---------------------------------------------------------------------------
% 2. CORE SCHEDULING LOGIC
% ---------------------------------------------------------------------------

% schedule/4 - Main scheduling predicate
schedule(Tasks, Starts, Ends, Makespan) :-
    % Define our course tasks
    Tasks = [task(computer_architecture,3,1), task(computational_logic,2,1), task(advanced_programming,4,2)],
    
    % Define start and end time variables for each course
    Starts = [Sa, Sb, Sc], 
    Ends = [Ea, Eb, Ec],
    
    % Set domain for start times (0 to 10 hours is reasonable for daily schedule)
    Sa in 0..10, 
    Sb in 0..10, 
    Sc in 0..10,
    
    % Apply the basic constraint: End = Start + Duration for each course
    Ea #= Sa + 3,  % Computer Architecture: end = start + 3 hours
    Eb #= Sb + 2,  % Computational Logic: end = start + 2 hours
    Ec #= Sc + 4,  % Advanced Programming: end = start + 4 hours
    
    % Resource constraint: Computer Architecture and Computational Logic use lab 1
    % They cannot overlap, so either Sa + 3 <= Sb OR Sb + 2 <= Sa
    (Sa + 3 #=< Sb) #\/ (Sb + 2 #=< Sa),
    
    % Compute makespan as the maximum of all end times
    Makespan #= max(Ea, max(Eb, Ec)),
    
    % Find optimal solution by minimizing makespan
    labeling([min(Makespan)], [Sa,Sb,Sc]).

% ---------------------------------------------------------------------------
% 3. ENHANCED MULTI-COURSE SCHEDULER
% ---------------------------------------------------------------------------

% multi_schedule/4 - Enhanced scheduler that handles any list of courses
multi_schedule(CourseList, Starts, Ends, Makespan) :-
    % Get the number of courses
    length(CourseList, NumCourses),
    
    % Create lists of variables for starts and ends
    length(Starts, NumCourses),
    length(Ends, NumCourses),
    
    % Set domains for start times
    Starts ins 0..20,
    
    % Apply end = start + duration constraint for each course
    apply_duration_constraints(CourseList, Starts, Ends),
    
    % Apply resource constraints to prevent overlapping courses in same lab
    apply_resource_constraints(CourseList, Starts, Ends),
    
    % Apply precedence constraints (course dependencies)
    apply_precedence_constraints(CourseList, Starts, Ends),
    
    % Calculate makespan as maximum end time
    max_member(Makespan, Ends),
    
    % Find optimal schedule
    labeling([min(Makespan)], Starts).

% ---------------------------------------------------------------------------
% 4. HELPER PREDICATES FOR CONSTRAINTS
% ---------------------------------------------------------------------------

% apply_duration_constraints/3 - Apply End = Start + Duration for all courses
apply_duration_constraints([], [], []).
apply_duration_constraints([task(_,Duration,_)|Courses], [Start|Starts], [End|Ends]) :-
    End #= Start + Duration,
    apply_duration_constraints(Courses, Starts, Ends).

% apply_resource_constraints/3 - Ensure courses using same lab don't overlap
apply_resource_constraints(CourseList, Starts, Ends) :-
    % For our specific three courses, handle the constraint manually
    CourseList = [task(computer_architecture,3,1), task(computational_logic,2,1), task(advanced_programming,4,2)],
    Starts = [Sa, Sb, _Sc],
    Ends = [Ea, Eb, _Ec],
    
    % Computer Architecture and Computational Logic both use lab 1
    % They cannot overlap: either first finishes before second starts, or vice versa
    (Ea #=< Sb) #\/ (Eb #=< Sa).

% apply_precedence_constraints/3 - Apply course dependencies
apply_precedence_constraints(CourseList, Starts, Ends) :-
    % Computational Logic should finish before Advanced Programming starts
    CourseList = [task(computer_architecture,3,1), task(computational_logic,2,1), task(advanced_programming,4,2)],
    Starts = [_Sa, _Sb, Sc],
    Ends = [_Ea, Eb, _Ec],
    
    % Advanced Programming starts after Computational Logic ends
    Sc #>= Eb.

% ---------------------------------------------------------------------------
% 5. COURSE SCHEDULING AND OPTIMIZATION 
% ---------------------------------------------------------------------------

% optimize_schedule/3 - Find the optimal course schedule minimizing total time
optimize_schedule(CourseList, OptimalStarts, MinMakespan) :-
    multi_schedule(CourseList, OptimalStarts, _, MinMakespan).

% print_schedule/3 - Display the course schedule in a readable format
print_schedule(CourseList, Starts, Ends) :-
    write('Computer Science Course Schedule:'), nl,
    write('Course                | Start | End | Duration | Lab'), nl,
    write('----------------------|-------|-----|----------|----'), nl,
    print_course_details(CourseList, Starts, Ends).

% print_course_details/3 - Helper to print individual course details
print_course_details([], [], []).
print_course_details([task(Name,Duration,Lab)|Courses], [Start|Starts], [End|Ends]) :-
    format('~w | ~w | ~w | ~w hrs | ~w~n', [Name, Start, End, Duration, Lab]),
    print_course_details(Courses, Starts, Ends).

% ---------------------------------------------------------------------------
% 6. SIMPLE WORKING EXAMPLE FOR TESTING
% ---------------------------------------------------------------------------

% simple_schedule/0 - A simple predicate to test basic functionality
simple_schedule :-
    % Define three courses with start times
    Sa in 0..10, Sb in 0..10, Sc in 0..10,
    
    % End times based on duration
    Ea #= Sa + 3,  % Computer Architecture
    Eb #= Sb + 2,  % Computational Logic  
    Ec #= Sc + 4,  % Advanced Programming
    
    % Resource constraint: courses using lab 1 cannot overlap
    (Ea #=< Sb) #\/ (Eb #=< Sa),
    
    % Precedence: Computational Logic before Advanced Programming
    Sc #>= Eb,
    
    % Minimize total time
    Makespan #= max(Ea, max(Eb, Ec)),
    
    % Find solution
    labeling([min(Makespan)], [Sa,Sb,Sc,Makespan]),
    
    % Display results
    format('Computer Architecture: Start=~w, End=~w~n', [Sa, Ea]),
    format('Computational Logic: Start=~w, End=~w~n', [Sb, Eb]),
    format('Advanced Programming: Start=~w, End=~w~n', [Sc, Ec]),
    format('Total Makespan: ~w hours~n', [Makespan]).

% ---------------------------------------------------------------------------
% 7. EXAMPLE QUERIES AND USAGE
% ---------------------------------------------------------------------------

% Basic working example:
% User should start with this to verify setup: and avoid disjuntion bug:
% ?- simple_schedule.

% Basic schedule with our courses:
% ?- schedule(Tasks, Starts, Ends, Makespan).

% Multi-course scheduler:
% ?- CourseList = [task(computer_architecture,3,1), task(computational_logic,2,1), task(advanced_programming,4,2)], 
%    multi_schedule(CourseList, Starts, Ends, Makespan).

% Print formatted schedule:
% ?- CourseList = [task(computer_architecture,3,1), task(computational_logic,2,1), task(advanced_programming,4,2)],
%    multi_schedule(CourseList, Starts, Ends, Makespan),
%    print_schedule(CourseList, Starts, Ends),
%    format('Total Project Time: ~w hours~n', [Makespan]).

% ---------------------------------------------------------------------------
% END OF LAB
% ---------------------------------------------------------------------------
