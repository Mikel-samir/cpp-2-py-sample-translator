/*
author : mikel S. youssef

*/



%% module organization

:- module(cfg,
	  [
	      strpc/3
	      ,nospace/3
	      ,topLevel/3
	      ]).


% string test
%%  S -> abS|` `S|e

strpc(X) -->
    ("ab",strpc(X1)
     ,{string_concat("cd",X1,X) }
    )
    ;(blank,strpc(X1) % " " doesn't work but blank work ,why ?
      ,{string_concat(" ",X1,X)}
     )
    ;("" ,{  X = "" }).


:- use_module(library(dcg/basics)).

%% top level
% 
topLevel (O) --> "".


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
stmt(Out) --> "{",stmts(Out),"}".

while_stmt --> "while" ,"(",cond,")", body.

cond --> var,bool_op,term.
%bool_op(S) --> ("<",{S=})

body --> stmt.
body --> "".

var(S) -->
    var_felm(F),velms(Cs),
    %    (nonblank(F1),{char_type(F1,csymf)}),chars(Cs),
    {append([F],Cs,Codes),string_codes(S,Codes)}.

%% variable components not really a char
%% it quites if wrong
velms(S) --> var_elm(S1),velms(S2),
	     {append([S1],S2,S)}.
velms(S) --> "",{S=[]}.


%% to be generalized
var_elm(Char,[Char|R],R) :-
     char_type_p(Char,csym,[Char|R],R).



var_felm(Char,[Char|R],R) :-
     char_type_p(Char,csymf,[Char|R],R).

%% general char filter
%% string vs code ??
char_type_p(Char,Type,[Char|R],R):-
    char_type(Char,Type).
char_type_p([],L,L).

bool_op_p(H,[H|R],R):-
    member(H,["<=","<"]).
bool_op_p([],L,L).


is_p(H,[H|T]) --> H.
is_p([],_) --> "".


%%% move to a lib file 
%% slice head and tail of list in reverse order

slice_(H,T,L):-
    reverse(L,[T|H1]),
    reverse(H1,H).

revappend(L,[],L).
revappend(H,T,L):-
    slice_(H1,T1,L),
    revappend(H2,T2,H1),
    H=H2,append_(T1,T2,T).

%% list check
list([]):-!.
list(L):-
    L=[_|_].
%%safe_append : append any to list
append_(L1,E,L3):-
    not(list(E)),list(L1),
    append(L1,[E],L3),!.
append_(X,Y,Z):-append(X,Y,Z),!.
append_(E1,E2,[E1,E2]):-
    not(list(E1)),not(list(E2)),!.
append_(E,L2,L3):-
    not(list(E)),list(L2),
    append([E],L2,L3),!.
    
    
    


    

