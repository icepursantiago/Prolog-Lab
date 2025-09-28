% Lab02: Prolog Expert System - Ecuadorian Animals Edition
% Author: Aispur Santiago
% Date: 2025-09-28

% 1. KNOWLEDGE BASE: ECUADORIAN ANIMAL IDENTIFICATION SYSTEM
% ---------------------------------------------------------------------------
% Below I define facts about animals and their properties.

% --- Animal Properties ---
has_fur(cat).
has_fur(dog).
has_fur(rabbit).
has_fur(cuy).        
has_fur(sea_lion).   

lays_eggs(chicken).
lays_eggs(duck).
lays_eggs(condor).   
lays_eggs(penguin).
lays_eggs(turtle).    

barks(dog).
meows(cat).
chirps(chicken).
quacks(duck).
roars(sea_lion).     
sings(condor).
squeaks(cuy).
swims(duck).
swims(penguin).
swims(sea_lion).
swims(turtle).
flies(duck).
flies(condor).
domesticated(cat).
domesticated(dog).
domesticated(rabbit).
domesticated(cuy).
domesticated(chicken).
domesticated(duck).

% ---------------------------------------------------------------------------
% 2. RULES FOR CLASSIFICATION
% ---------------------------------------------------------------------------

is_mammal(X)    :- has_fur(X).
is_bird(X)      :- lays_eggs(X), flies(X).
is_reptile(X)   :- lays_eggs(X), \+ has_fur(X), \+ flies(X).
is_domesticated(X) :- domesticated(X).
can_fly(X)      :- flies(X).
can_swim(X)     :- swims(X).

matches(X) :-
    (has_fur(X); lays_eggs(X)),
    (barks(X); meows(X); chirps(X); quacks(X); roars(X); sings(X); squeaks(X); swims(X); flies(X)).

% 3. INTERACTIVE QUESTIONS
% ---------------------------------------------------------------------------

ask(Question, Answer) :-
    write(Question), write(' (yes/no): '), nl,
    read(Answer).

identify_animal(Animal) :-
    ask('Does it have fur?', Fur),
    ( Fur == yes ->
        ask('Does it bark?', Bark),
        ( Bark == yes -> Animal = dog ;
          ask('Does it meow?', Meow),
          ( Meow == yes -> Animal = cat ;
            ask('Is it domesticated?', Domest),
            ( Domest == yes ->
                ask('Does it squeak?', Squeak),
                ( Squeak == yes -> Animal = cuy ; Animal = rabbit )
              ; ask('Does it roar?', Roar),
                ( Roar == yes -> Animal = sea_lion ; Animal = rabbit )
            )
          )
        )
      ;
        ask('Does it lay eggs?', Eggs),
        ( Eggs == yes ->
            ask('Can it fly?', Fly),
            ( Fly == yes ->
                ask('Does it sing?', Sing),
                ( Sing == yes -> Animal = condor ;
                  ask('Does it quack?', Quack),
                  ( Quack == yes -> Animal = duck ; Animal = chicken )
                )
              ;
                ask('Can it swim?', Swim),
                ( Swim == yes ->
                    ask('Is it large?', Large),
                    ( Large == yes -> Animal = sea_lion ; Animal = penguin )
                  ; ask('Is its shell hard?', Shell),
                    ( Shell == yes -> Animal = turtle ; Animal = penguin )
                )
            )
          ;
            ask('Can it swim?', Swim2),
            ( Swim2 == yes -> Animal = sea_lion ; Animal = rabbit )
        )
    ),
    write('I think the animal is: '), write(Animal), nl.


% 4. EXTENSIONS AND AMBIGUITY HANDLING
% ---------------------------------------------------------------------------

possible_animals(List) :-
    findall(A, matches(A), List).


% 5. CLASSIFICATION TREE (ANCESTOR-TYPE REASONING)
% ---------------------------------------------------------------------------

vertebrate(X) :- has_fur(X).
vertebrate(X) :- lays_eggs(X).

mammal(X) :- vertebrate(X), has_fur(X).
bird(X) :- vertebrate(X), lays_eggs(X), can_fly(X).
reptile(X) :- vertebrate(X), lays_eggs(X), \+ can_fly(X), \+ has_fur(X).

ancestor_class(mammal, dog).
ancestor_class(mammal, cat).
ancestor_class(mammal, rabbit).
ancestor_class(mammal, cuy).
ancestor_class(mammal, sea_lion).
ancestor_class(bird, duck).
ancestor_class(bird, condor).
ancestor_class(bird, chicken).
ancestor_class(bird, penguin).
ancestor_class(reptile, turtle).

ancestor_class(vertebrate, X) :- ancestor_class(mammal, X).
ancestor_class(vertebrate, X) :- ancestor_class(bird, X).
ancestor_class(vertebrate, X) :- ancestor_class(reptile, X).

% ---------------------------------------------------------------------------
% 6. EXAMPLE QUERIES AND EXPLANATIONS
% ---------------------------------------------------------------------------

% 1. Basic Run: Test with default animals
%    ?- identify_animal(A).
%    The system will interactively ask questions and deduce the animal.

% 2. Knowledge Expansion: More animals and properties have been added above.

% 3. Generalization:
%    ?- can_fly(condor).
%    true.
%    ?- can_swim(sea_lion).
%    true.

% 4. Ambiguity Handling:
%    ?- possible_animals(List).
%    Returns a list of all candidate animals matching some properties.

% 5. Recursive Classification:
%    ?- ancestor_class(vertebrate, cuy).
%    true.
%    ?- ancestor_class(mammal, sea_lion).
%    true.

% ---------------------------------------------------------------------------
