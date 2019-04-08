%%%-------------------------------------------------------------------
%%% @author jakubrog
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. Apr 2019 10:24 AM
%%%-------------------------------------------------------------------
-module(pingpong).
-author("jakubrog").

%% API
-export([start/0, stop/0, loop/0, play/1]).

start() ->
  register(ping, spawn(?MODULE, loop, [])),
  register(pong, spawn(?MODULE, loop, [])),
  ok.

stop() ->
  ping ! stop,
  pong ! stop.

loop() ->
  receive
    stop -> ok;
    {Pid, N} when N > 0 ->
      timer:sleep(1000),
      io:format("PID: ~p odbija ~p~n",[self(), N]),
      Pid ! {self(), N - 1},
      loop()
    after
      20000 -> ok
  end.

play(N) ->
  ping ! {whereis(pong) , N},
  ok.
