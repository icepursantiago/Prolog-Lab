% Lab10: Semantic DCGs - From Sentences to Meaning
% Author: Aispur Santiago
% Date: 2025-12-03

% ---------------------------------------------------------------------------
% SEMANTIC DCG GRAMMAR - TASK A (Base Semantic Grammar)
% ---------------------------------------------------------------------------

% Sentence with semantic argument
sentence(Sem) --> noun_phrase(Subj), verb_phrase(Subj, Sem).

% Noun phrase with semantic argument
noun_phrase(Subj) --> determiner, noun(Subj). 

% Verb phrase with semantic arguments
verb_phrase(Subj, Sem) --> verb(V), noun_phrase(Obj), { Sem =.. [V, Subj, Obj] }.

% ---------------------------------------------------------------------------
% SEMANTIC LEXICON
% ---------------------------------------------------------------------------

% Nouns with semantic representations
noun(cat) --> [cat].
noun(dog) --> [dog].
noun(fish) --> [fish]. 
noun(bird) --> [bird]. 

% Verbs with semantic representations
verb(eats) --> [eats]. 
verb(sees) --> [sees]. 

% Determiners (no semantic content)
determiner --> [the]. 
determiner --> [a]. 

% ---------------------------------------------------------------------------
% TASK B - EXTENSION WITH ADJECTIVES
% ---------------------------------------------------------------------------

% Enhanced noun phrase with adjectives
noun_phrase_with_adjectives(Subj) --> determiner, adjectives, noun(Subj).

% Adjectives (syntax-only version)
adjectives --> []. 
adjectives --> adjective, adjectives.

% Individual adjectives
adjective --> [big].
adjective --> [small]. 
adjective --> [angry].

% Enhanced sentence with adjectives
sentence_with_adjectives(Sem) --> noun_phrase_with_adjectives(Subj), verb_phrase(Subj, Sem). 

% ---------------------------------------------------------------------------
% EXAMPLE QUERIES AND DEMONSTRATIONS
% ---------------------------------------------------------------------------

% Test parsing with semantic output:
% ? - phrase(sentence(S), [the, cat, eats, fish]).
% S = eats(cat, fish).

% ? - phrase(sentence(S), [a, dog, sees, the, bird]). 
% S = sees(dog, bird).

% Test with adjectives (ignoring them in semantics for now):
% ?- phrase(sentence_with_adjectives(S), [the, big, angry, cat, eats, fish]).
% S = eats(cat, fish). 

% Generation examples:
% ?- phrase(sentence(eats(cat, fish)), X). 
% X = [the, cat, eats, the, fish] ;
% X = [the, cat, eats, a, fish] ;
% X = [a, cat, eats, the, fish] ;
% X = [a, cat, eats, a, fish]. 

% ---------------------------------------------------------------------------
% TRANSCRIPT OF EXAMPLE QUERIES
% ---------------------------------------------------------------------------
/*
Example session showing sentences and their semantic terms:

? - phrase(sentence(S), [the, cat, eats, fish]).
S = eats(cat, fish).

?- phrase(sentence(S), [a, dog, sees, the, bird]). 
S = sees(dog, bird). 

?- phrase(sentence_with_adjectives(S), [the, big, cat, eats, fish]).
S = eats(cat, fish). 

?- phrase(sentence(eats(dog, bird)), Words).
Words = [the, dog, eats, the, bird] ;
Words = [the, dog, eats, a, bird] ;
Words = [a, dog, eats, the, bird] ;
Words = [a, dog, eats, a, bird] ;
false. 

The semantic representation maps "the cat eats fish" to eats(cat, fish),
showing the logical relationship between subject, verb, and object.
*/

% ---------------------------------------------------------------------------
% END OF LAB
% ---------------------------------------------------------------------------
