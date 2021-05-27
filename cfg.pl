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

%% variable elems parser
%% it quites if wrong
velms(S) --> var_elm(S1),velms(S2),
	     {append([S1],S2,S)}.
velms(S) --> "",{S=[]}.
%% elem
var_elm(Char,[Char|R],R) :-
     char_type_p(Char,csym,[Char|R],R).
%% first elem
var_felm(Char,[Char|R],R) :-
     char_type_p(Char,csymf,[Char|R],R).

%% char type parser
char_type_p(Char,Type,[Char|R],R):-
    char_type(Char,Type).
char_type_p([],L,L).
    
    
    


    

