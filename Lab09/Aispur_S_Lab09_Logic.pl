% Lab09: Mini English Grammar with DCGs
% Author: Aispur Santiago
% Date: 2025-11-18

% ---------------------------------------------------------------------------
% DCG Grammar for English sentences (with adjectives)
% ---------------------------------------------------------------------------

% Sentence: noun_phrase followed by verb_phrase
sentence --> noun_phrase, verb_phrase.

% Noun Phrase: determiner, zero or more adjectives, noun
noun_phrase --> determiner, adjectives, noun.

% Adjectives: zero or more adjectives
adjectives --> [].
adjectives --> adjective, adjectives.

% Adjective
adjective --> [big].
adjective --> [small].
adjective --> [angry].

% Noun
noun --> [cat].
noun --> [dog].
noun --> [fish].
noun --> [bird].

% Determiner
determiner --> [the].
determiner --> [a].

% Verb Phrase: verb, noun_phrase
verb_phrase --> verb, noun_phrase.

% Verb
verb --> [eats].
verb --> [sees].

% ---------------------------------------------------------------------------
% DEMONSTRATIONS
% ---------------------------------------------------------------------------

% Example: Parse sentence structure
% ?- phrase(sentence, [the, cat, eats, fish]).
% true.
%
% ?- phrase(sentence, [dog, the, eats]).
% false.

% Example: Generate sentences
% ?- phrase(sentence, X).
% X = [the, cat, eats, the, cat] ;
% X = [the, cat, eats, the, dog] ;
% X = [the, cat, eats, the, fish] ;
% X = [the, cat, eats, the, bird] ;
% X = [the, cat, eats, a, cat] ;
% ... (press ';' to see more solutions, as required)

% The DCG supports multiple adjectives:
% ?- phrase(sentence, [the, small, angry, dog, eats, a, fish]).
% true.

% ---------------------------------------------------------------------------
% END OF LAB
% ---------------------------------------------------------------------------
