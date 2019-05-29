%%%-------------------------------------------------------------------
%%% @author jakubrog
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. May 2019 19:03
%%%-------------------------------------------------------------------
-module(pollution_server).
-author("jakubrog").

%% API
-export([]).

-compile(export_all).


start() ->
  P = pollution:createMonitor(),
  register(monitor, spawn(?MODULE, loop, [P])),
  ok.


loop(P) ->
  receive
    {Pid, addStation, Name, {Lat, Lon}} ->
      P1 = pollution:addStation(Name, {Lat,Lon}, P),
      Pid ! P1,
      loop(P1);
    {Pid, removeValue, Name, Time, Type} ->
      P1 = pollution:removeValue(Name, Time, Type, P),
      Pid ! P1,
      loop(P1);
    {Pid, addValue, Name, Time, Type, Result} ->
      P1 = pollution:addValue(Name, Time, Type, Result, P),
      io:format("1"),
      Pid ! P1,
      loop(P1);
    {Pid, getStationMean, Name, Type} ->
      Pid ! pollution:getStationMean(Name, Type, P),
      loop(P);
    {Pid, getDailyMean,Time, Type} ->
      Pid ! pollution:getDailyMean(Time, Type),
      loop(P);
    {Pid, getMaximumGradientStation,Type} ->
      Pid ! pollution:getMaximumGradientStation(Type, P),
      loop(P);
    {Pid, getOneValue, Name, Time, Type} ->
      Pid ! pollution:getOneValue(Name, Time,Type, P),
      loop(P);
    {Pid, getStationMeanWithTime, Name, Type, Time} ->
      Pid ! pollution:getStationMeanWithTime(Name, Type, Time,  P),
      loop(P);
    {Pid, crash} ->
      1/0;
    stop ->
      ok;
    _ ->
      loop(P)
  end.

addStation(Name, Geo) ->
  monitor ! {self(), addStation, Name, Geo},
  receive
    Result ->
      Result
  end.

addValue(Name, Time, Type, Result) ->
  monitor ! {self(), addValue, Name, Time, Type, Result},
  io:format("2"),
  receive
    Result ->
      Result
  end.

removeValue(Name, Time, Type) ->
  monitor ! {self(), removeValue, Name, Time, Type},
  receive
    Result ->
      Result
  end.

getOneValue(Name, Time, Type ) ->
  monitor ! {self(), getOneValue, Name, Time, Type},
  receive
    Result ->
      Result
  end.

getStationMean(Name, Type) ->
  monitor ! {self(), getStationMean, Name, Type},
  receive
    Result ->
      Result
  end.

getStationMeanWithTime(Name, Type, Time) ->
  monitor ! {self(), getStationMeanWithTime, Name, Type, Time},
  receive
    Result ->
      Result
  end.

getDailyMean(Time, Type) ->
  monitor ! {self(), getDailyMean, Time, Type},
  receive
    Result ->
      Result
  end.

getMaximumGradientStation(Type) ->
  monitor ! {self(), getMaximumGradientStation, Type},
  receive
      Result ->
        Result
  end.


crash() -> monitor ! {self(), crash}.

stop()->
  monitor ! stop.


test() ->
  start(),
  addStation("Hello", {10,20}),
  addStation("Hello2", {30,40}).
%%  addValue("Hello2", 10, "PM12", 10),
%%  addValue("Hello2", 10, "PM25", 100),
%%  addValue("Hello", 11, "PM12", 10),
%%  addValue("Hello", 10, "PM12", 100).



