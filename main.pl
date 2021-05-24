
[cfg].

cpp_parser(X) --> strpc(X).

run :-
    %% read
    phrase_from_file(cpp_parser(Out), 'source_file'),
    %% write
    open('target_file',write,OS),
    write(OS,Out),
    write(OS,"\n"),
    close(OS).
