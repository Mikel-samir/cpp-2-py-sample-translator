
:- module(translator,[
	      py_cond/4
	      ,py_while/3
	      ,py_stmts/3
	      ,py_stmt/2
	      ,py_assign1/3
	      ,py_if/4
%%       , .....
	  ]).

:- use_module(library(strings)).
:- use_module(prelude,
	      [string_list_concat/2 as string_concat_list]).

py_stmts(A,B,Out):-
    string_concat_list([A,";",B],Out).
py_stmt(A,Out):-
    string_concat_list(["{",A,"}"],Out).			% curlly brackets
py_assign1(Var,Num,Out):-
    string_concat_list([Var,"=",Num],Out).

py_cond(T1,Op,T2,O):-
    string_concat_list([T1," ",Op," ",T2],O).

py_while(Cond,Body,Out):-
    indent_lines("\t",Body,B),
    string_concat_list(["while (",Cond,") : \n",B],Out).

py_if(Cond,Body,Rest,Out).
py_elseif(Cond,Body,Rest,Out).
py_else(Body,Out).

py_doWhile(Body,Cond,Out).

/** <examples>
  ?- cpp_while("x < 1","x=2\nx=5",O),write(O). 
 */

/*
ex.
while (x < 1) : 
	x=2
	x=5
*/
