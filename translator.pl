

:- use_module(library(strings)).

cpp_while(Cond,Body,Out):-
    X = "while (",
    string_concat(X,Cond,X1),
    string_concat(X1,") : \n",X2),
    indent_lines("\t",Body,X3),
    string_concat(X2,X3,Out).

/** <examples>
  ?- cpp_while("x < 1","x=2\nx=5",O),write(O). 
 */

/*
ex.
while (x < 1) : 
	x=2
	x=5
*/
