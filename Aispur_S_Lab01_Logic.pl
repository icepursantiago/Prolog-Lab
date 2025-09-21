% Lab01: Prolog Knowledge Base and Query
% Author: Aispur Santiago
% Date: 2025-09-21

% 1. FAMILY TREE KNOWLEDGE BASE
% ---------------------------------------------------------------------------
% Family facts
parent(carmelina, ramiro).
parent(ramiro, andres).
parent(carmelina, patty).
parent(carmelina, lucia).
parent(carmelina, santty).
parent(carmelina, cecilia).
parent(cecilia, fernanda).
parent(fernanda, sergio).

% Grandparent: X is grandparent of Y if X is parent of Z and Z is parent of Y.
grandparent(X, Y) :- parent(X, Z), parent(Z, Y).

% Sibling: X and Y are siblings if they share a parent and are not the same individual.
sibling(X, Y) :- parent(Z, X), parent(Z, Y), X \= Y.

% Ancestor: X is ancestor of Y if X is parent of Y, or if X is parent of Z and Z is ancestor of Y.
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).

% 3. FOOD PREFERENCES
% ---------------------------------------------------------------------------
% Food preferences facts
likes(carmelina, fritada).
likes(ramiro, barbecue).
likes(patty, pasta).
likes(lucia, hornado).
likes(santty, sushi).
likes(cecilia, fritada).
likes(fernanda, sushi).
likes(andres, sushi).
likes(sergio, pasta).

% food_friend/2
% X and Y are food friends if they like the same food and are not the same person.
food_friend(X, Y) :- likes(X, Food), likes(Y, Food), X \= Y.

% 4. MATH UTILITY PREDICATES
% ---------------------------------------------------------------------------

% factorial/2 (recursive)
% Computes the factorial of a non-negative integer N.
factorial(0, 1).
factorial(N, F) :-
    N > 0,
    N1 is N - 1,
    factorial(N1, F1),
    F is N * F1.

% sum_list/2 (recursive)
% Succeeds if Sum is the sum of all elements in List.
sum_list([], 0).
sum_list([H|T], Sum) :-
    sum_list(T, Rest),
    Sum is H + Rest.

% 5. LIST PROCESSING PREDICATES
% ---------------------------------------------------------------------------

% length_list/2 (recursive)
% Computes the number of elements in a list.
length_list([], 0).
length_list([_|T], Length) :-
    length_list(T, L1),
    Length is L1 + 1.

% append_list/3 (recursive)
% Concatenates two lists: Result is the concatenation of List1 and List2.
append_list([], L, L).
append_list([H|T], L2, [H|R]) :-
    append_list(T, L2, R).

% ---------------------------------------------------------------------------
% 6. EXAMPLE QUERIES AND EXPLANATIONS
% ---------------------------------------------------------------------------
% The following queries demonstrate how to use the knowledge base and predicates above.

% 1. Ancestors of a specific person:
%    ?- ancestor(X, santty).
%    Returns the ancestors of santty (should include lucia and carmelina).

% 2. Siblings in the family tree:
%    ?- sibling(X, Y).
%    Returns all sibling pairs.

% 3. Food friends:
%    ?- food_friend(X, Y).
%    Returns pairs of people who like the same food.

% 4. Factorial of 6:
%    ?- factorial(6, F).
%    F = 720.

% 5. Sum of [2,4,6,8]:
%    ?- sum_list([2,4,6,8], S).
%    S = 20.

% 6. Length of [a,b,c,d]:
%    ?- length_list([a,b,c,d], L).
%    L = 4.

% 7. Append [1,2] and [3,4]:
%    ?- append_list([1,2], [3,4], R).
%    R = [1,2,3,4].

