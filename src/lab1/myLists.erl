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
-export([contains/2, duplicateElements/1, sumFloats/1, sum/1, rpn_calculator/1]).

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


rpn_calculator(A) ->
  calculate(A, []).

calculate([], Stack) -> Stack;
calculate([Num|Rest], Stack) when is_number(Num) ->
  calculate(Rest, [Num | Stack]);
calculate(["+" | Rest], [A | [B | Stack]]) when is_number(A) andalso is_number(B) ->
  calculate(Rest, [B+A | Stack]);
calculate(["-" | Rest], [A | [B | Stack]]) when is_number(A) andalso is_number(B) ->
  calculate(Rest, [B-A | Stack]);
calculate(["/" | Rest], [A | [B | Stack]]) when is_number(A) andalso is_number(B) ->
  calculate(Rest, [B/A | Stack]);
calculate(["*" | Rest], [A | [B | Stack]]) when is_number(A) andalso is_number(B) ->
  calculate(Rest, [B*A | Stack]);
calculate(["sqrt" | Rest], [A | Stack]) when is_number(A) andalso A >= 0 ->
  calculate(Rest, [math:sqrt(A) | Stack]);
calculate(["sin" | Rest], [A | Stack]) when is_number(A) ->
  calculate(Rest, [math:sin(A) | Stack]);
calculate(["cos" | Rest], [A | Stack]) when is_number(A) ->
  calculate(Rest, [math:cos(A) | Stack]);
calculate(["tan" | Rest], [A | Stack]) when is_number(A) ->
  calculate(Rest, [math:tan(A) | Stack]);
calculate(["pow" | Rest], [A | [B | Stack]]) when is_number(A) andalso is_number(B) ->
  calculate(Rest, [math:pow(A,B)| Stack]);
calculate(_, _) ->
  io:format("error ").




