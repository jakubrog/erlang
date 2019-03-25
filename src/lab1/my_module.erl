%%%-------------------------------------------------------------------
%%% @author jakubrog
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Mar 2019 10:07
%%%-------------------------------------------------------------------
-module(my_module).
-author("jakubrog").
-export([pow/2]).

% zad 2
pow(_, 0) -> 1;
pow(A, 1) -> A;
pow(A, N) -> A * pow(A, N-1).
