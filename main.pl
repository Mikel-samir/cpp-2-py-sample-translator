%% [cfg].				%importing doesn't work
:- use_module(cfg).
cpp_parser(X) --> topLevel(X).	% strpc false only with phrase_from_file

run:- run(_).
run(Out) :-
    %% read
    phrase_from_file(cpp_parser(Codes), 'source_file.cpp'),
     string_codes(Out,Codes),	% to ensure that it is a string
    %% write
    open('target_file.py',write,OS),
    write(OS,Out),
    write(OS,"\n"),
    close(OS).
