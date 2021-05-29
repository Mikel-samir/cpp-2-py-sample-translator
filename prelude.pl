
:- module(prelude,[
	      string_list_concat/2
	      ,revappend/3
	      ,list/1
	      ,append_/3
	      ,nl/2
	      ,word_upper/2
	  ]).

%% general char filter
%% string vs code ??
char_type_p(Char,Type,[Char|R],R):-
    char_type(Char,Type).
char_type_p([],L,L).

bool_op_p(H,[H|R],R):-
    member(H,["<=","<"]).
bool_op_p([],L,L).


is_p(H,[H|_]) --> H.
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

string_list_concat([H|T],S):-
    string_list_concat(T,S1),
    string_concat(H,S1,S).
string_list_concat([H],S):-
    S=H. 

nl(In,In):-
    %%  add newline if string doesn't end with new line
    string_codes(In,Codes),
    last(Codes,10).

nl(In,Out):-
    string_concat(In,"\n",Out).

word_upper(Word,W_ord):-
    %% turn first char to upper
    string_codes(Word,C),
    C=[X|R],
    string_codes(Y,[X]),
    string_upper(Y,Upper),
    string_codes(Rest,R),
    string_concat(Upper,Rest,W_ord).
