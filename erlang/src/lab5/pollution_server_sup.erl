%%%-------------------------------------------------------------------
%%% @author jakubrog
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. May 2019 13:21
%%%-------------------------------------------------------------------
-module(pollution_server_sup).
-author("jakubrog").

%% API
-export([start/0, loop/0]).


start() ->
  pollution_server_sup:start(),
  spawn(?MODULE, loop, []).


loop()->
  process_flag(trap_exit, true),
  receive
    {'EXIT', Pid, Reason} ->
      io:format("Start again"),
      loop()
  end.
