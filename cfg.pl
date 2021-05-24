
% string test
%%  S -> abS|` `S|e

strpc(X) -->
    ("ab",strpc(X1)
     ,{string_concat("cd",X1,X) }
    )
    ;(" ",strpc(X1)
      ,{string_concat(" ",X1,X)}
     )
    ;("" ,{  X = "" }).


    
    
