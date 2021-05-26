/*
author : mikel S. youssef

*/


/*
%% module organization
:- module(cfg,
	  [
	      strpc/3
	   ,
	       topLevel/3
	      ]).
*/

% string test
%%  S -> abS|` `S|e
strpc(X) -->
    ("ab",strpc(X1)
     ,{string_concat("cd",X1,X) }
    )
    ;(" ",strpc(X1)
      ,{string_concat(" ",X1,X)}
     )
    ;("" ,{  X = "" }).


:- use_module(library(dcg/basics)).

%% top level
% 
topLevel --> "".


%% tokens
nospace(O) -->
    (blank,nospace(O))

    ;(nonblank(C),nospace(O1),{string_codes(S,[C]),string_concat(S,O1,O)})

    ;("", { O="" }).
%% alternative method 
string_list_concat([H|T],S):-
    string_list_concat(T,S1),
    string_concat(H,S1,S).

string_list_concat([H],S):-
    S=H. 

%split_string("ab ab\n \tdd fmf"," ","\n\t",L),string_list_concat(L,O).


%% cfg grammar

stmts(Out) --> stmt(Out1) , ";", stmts(Out2).
stmts(Out) --> "".

stmt(Out) --> while_stmt(Out).
stmt(Out) --> stmts(Out).

while_stmt --> "(",cond,")", body.

cond --> var,bool_op,term.

var(S) -->
    var_felm(F),velms(Cs),
    %    (nonblank(F1),{char_type(F1,csymf)}),chars(Cs),
	   {string_concat(F,Cs,S)}.

%% variable components not really a char
%% it quites if wrong
velms(S) --> var_elm(S1),velms(S2),
	     {string_concat(S1,S2,S)}.
velms(S) --> "",{S=""}.


%% to be generalized
var_elm(S,[S1|R],R) :-
     char_type(S1,csym),
      string_codes(S,[S1]).
var_elem("",L,L).


var_felm(S,[S1|R],R) :-
     char_type(S1,csymf),
      string_codes(S,[S1]).
var_felm("",L,L).

%% general char filter
%% string vs code ??
char_type_p(Char,Type,[Char|R],R):-
    char_type(Char,Type).
char_type_p([],L,L).

var_elm1(S,[S1|R],R) :-
     char_type_p(S1,csymf,[S1|R],R),
      string_codes(S,[S1]).
