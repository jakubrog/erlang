%%%-------------------------------------------------------------------
%%% @author jakubrog
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Mar 2019 10:14
%%%-------------------------------------------------------------------
-module(myLists).
-author("jakubrog").

%% API
-export([contains/2, duplicateElements/1, sumFloats/1, sum/1]).

% zad 4
contains([H|_] , H) -> true;
contains([],_) -> false;
contains([_|T], H) -> contains(T, H).


duplicateElements([]) -> [];
duplicateElements([H | T]) -> [H] ++ [H] ++ duplicateElements(T).



sumFloats([]) -> 0;
sumFloats([X | T]) when is_float(X) -> X + sumFloats(T);
sumFloats([_|T])-> sumFloats(T).

sum(X) when is_list(X) ->  sumFloatsTail(X, 0);
sum(_) -> 0.

sumFloatsTail([], A) -> A;
sumFloatsTail([X | T], A) when is_float(X) -> sumFloatsTail(T, A + X);
sumFloatsTail([_|T],A)-> sumFloatsTail(T, A).

