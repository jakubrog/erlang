%%%-------------------------------------------------------------------
%%% @author jakubrog
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Apr 2019 13:05
%%%-------------------------------------------------------------------
-module(pingpong).
-author("jakubrog").

%% API
-export([start/0, stop/0, play/1, loop/1]).

start() ->
  register(ping, spawn(?MODULE, loop, [0])),
  register(pong, spawn(?MODULE, loop, [0])),
  ok.

stop() ->
  ping ! stop,
  pong ! stop.

loop(Sum)->
  receive
    stop -> ok;
    {Pid, N} when N > 0 ->
      timer:sleep(1000),
      io:format("PID: ~p odbija ~p, suma ~p~n",[self(), N, Sum+N]),
      Pid ! {self(), N - 1},
      pingpong:loop(Sum+N);
     _ -> pingpong:loop(Sum)
    after
      20000 -> io:format("Pid ~p ended~n", [self()])
  end.

play(N) ->
  ping ! {whereis(pong), N},
  ok.