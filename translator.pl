


:- use_module(library(strings)).
:- use_module(prelude,string_list_concat/2 as string_concat_list).


py_cond(T1,Op,T2,O):-
    string_concat_list([T1," ",Op," ",T2],O).

py_while(Cond,Body,Out):-
    indent_lines("\t",Body,B),
    string_concat_list(["while (",X,Cond,") : \n",B],Out).

/** <examples>
  ?- cpp_while("x < 1","x=2\nx=5",O),write(O). 
 */

/*
ex.
while (x < 1) : 
	x=2
	x=5
*/
