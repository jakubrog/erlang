%%%-------------------------------------------------------------------
%%% @author jakubrog
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 27. Mar 2019 1:11 PM
%%%-------------------------------------------------------------------
-module(qsort).
-author("jakubrog").

%% API
-export([lessThan/2]).

lessThan(List, Arg) ->
  [X || X <- List, X < Arg].