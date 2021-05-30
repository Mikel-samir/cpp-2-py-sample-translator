
:- module(translator,[
	      py_cond/4
	      ,py_while/3
	      ,py_doWhile/3	      
	      ,py_stmts/3
              ,py_stmt/2
	      ,py_assign1/3
	      ,py_if/4
	      ,py_elseif/4
	      ,py_else/2
	      ,py_expr1/4
	      ,py_truefalse/2
	      ,py_for/5
	      ,py_assign2/4
%%       , .....
	  ]).

:- use_module(library(strings)).
:- use_module(prelude,
	      [string_list_concat/2 as string_concat_list
	       ,nl/2 % conditional new line
	       ,word_upper/2
	       ,string_head/2
	      ]).

py_stmts(A,B,Out):-
    nl(A,A_),
    string_concat_list([A_,B],Out).
py_stmt(A,A_):-
    nl(A,A_).
%% py_stmt(A,B):- string_concat_list([A,"\n"],B).
 %% indent_lines("\t",A,Out).			% curlly brackets
py_assign1(Var,Num,Out):-
    string_concat_list([Var,"=",Num],Out).

py_assign2(Var,Sign,Num,Out):-
    string_head(Sign,S),
    string_concat_list([Var,S,"=",Num],Out).


py_cond(T1,Op,T2,O):-
    string_concat_list([T1," ",Op," ",T2],O).
py_expr1(T,S,E,Out):-
    string_concat_list([T,S,E],Out).

py_expr2(E1,E2,Out).

py_while(Cond,Body,Out):-
    indent_lines("\t",Body,B),
    string_concat_list(["while (",Cond,") : \n",B],Out).

py_if(Cond,Body,Rest,Out):-
    indent_lines("\t",Body,B),
    string_concat_list(["if (",Cond,") : \n",B,Rest],Out).
py_elseif(Cond,Body,Rest,Out):-
    indent_lines("\t",Body,B),
    string_concat_list(["elif (",Cond,") : \n",B,Rest],Out).
py_else(Body,Out):-
    indent_lines("\t",Body,B),
    string_concat_list(["else  : \n",B],Out).

py_doWhile(Body,Cond,Out):-
    indent_lines("\t",Body,B),
    string_concat_list(["while(True):# fake do while\n",B
			,"\tif ( not (",Cond,") ):\n\t\tbreak"],Out).
py_truefalse(In,Out):-
    word_upper(In,Out).

py_for(Astmt,Cond,X,Body,Out):-
    indent_lines("\t",Body,B),
    string_concat_list([Astmt
			,"\nwhile (",Cond,") :# fake for loop \n"
			,B,"\n\t",X],Out).

/** <examples>
  ?- cpp_while("x < 1","x=2\nx=5",O),write(O). 
 */

/*
ex.
while (x < 1) : 
	x=2
	x=5
*/
