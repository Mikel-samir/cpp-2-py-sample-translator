/*
author : mikel S. youssef

*/



%% dirs

:- module(cfg,
	  [
	      strpc/3
	      ,nospace/3
	      ,topLevel/3
	      ]).
:- use_module(library(dcg/basics)).
:- use_module(translator).
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




%% Top level
% 

topLevel(O) --> nospace( Stream),{phrase(stmts(O),Stream,Rest)}.
%% topLevel("failed")-->"",!.


/*
topLevel(O,S,R):-
    nospace(O1,S,_),
    stmts(O,O1,R).
topLevel("failed",_,_).
*/
%% tokens
nospace(O) -->
    (blank,nospace(O))

    ;(nonblank(C),nospace(O1)
      ,{append([C],O1,O)})

    ;("", { O=[] }).
%% alternative method 

%split_string("ab ab\n \tdd fmf"," ","\n\t",L),string_list_concat(L,O).


%% cfg grammar

stmts(Out) --> stmt(Out1) , stmts(Out2),{py_stmts(Out1,Out2,Out)}.

stmts("") --> "".

stmt(Out) --> while_stmt(Out).
stmt(Out) --> doWhile_stmt(Out),";".
stmt(Out) --> if_stmt(Out).
stmt(Out) --> assign_stmt(Out),";".
stmt(Out) --> "{",stmts(Out),"}".


if_stmt(Out) --> "if","(",cond(C),")",body(B),else_stmt(E)
		 ,{py_if(C,B,E,Out)}.

else_stmt(Out) --> "else","if","(",cond(C),")",body(B),else_stmt(E)
		 ,{py_elseif(C,B,E,Out)}.

else_stmt(Out) --> "else",body(B)
		 ,{py_else(B,Out)}.
else_stmt("") --> "".


doWhile_stmt(O) --> "do", body(B),"while" ,"(",cond(C),")"
		  ,{py_doWhile(B,C,O)}.

while_stmt(O) --> "while" ,"(",cond(C),")", body(B)
		  ,{py_while(C,B,O)}.

cond(O) -->
    (match_list(O,["true","false"]))
    ;(term(T1),bool_op(B),term(T2),{py_cond(T1,B,T2,O)}).
bool_op(S) --> match_list(S,["<=","<",">=",">","=="]).
term(T)--> number(T);var(T).

body(O) --> stmt(O).
body("") --> "".


assign_stmt(O) --> var(V) , "=", number(X),{py_assign1(V,X,O)}.
assign_stmt(O) --> var(V) , "=", expr(X),{py_assign1(V,X,O)}.

expr(X) --> term(A),match_list(S,["+","-","*","/","^"]),expr(E)
	    ,{py_expr1(A,S,E,X)}.
expr(X) --> term(X).

var(S) -->
    var_felm(F),velms(Cs),
    %    (nonblank(F1),{char_type(F1,csymf)}),chars(Cs),
    {append([F],Cs,Codes),string_codes(S,Codes)}.

%% variable elems parser
%% it quites if wrong
velms(S) --> var_elm(S1),velms(S2),
	     {append([S1],S2,S)}.
velms([]) --> "".

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
    
%% match againest a list and returns the match
%% order matters ,return string from the list
match_list(H,[H|_],S,R):-
    phrase(H,S,R).
match_list(H,[_|T],S,R):-
    match_list(H,T,S,R).


    

