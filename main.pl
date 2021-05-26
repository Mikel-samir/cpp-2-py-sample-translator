
%%[cfg].
:- use_module(cfg).

cpp_parser(X) --> strpc(X).

run :-
    %% read
    phrase_from_file(cpp_parser(Codes), 'source_file'),
    string_codes(Codes,Out),
    %% write
    open('target_file',write,OS),
    write(OS,Out),
    write(OS,"\n"),
    close(OS).
