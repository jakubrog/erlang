%%%-------------------------------------------------------------------
%%% @author jakubrog
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 10. Apr 2019 13:20
%%%-------------------------------------------------------------------
-module(pollution_server).
-author("jakubrog").
-include_lib("pollution.erl").
%% API
%%-export([start/0, loop/1, addStation/2, addValue/4, removeValue/3, getOneValue/3, getStationMean/2]).
-compile(export_all).


start() ->
  P = pollution:createMonitor(),
  register(monitor, spawn(?MODULE, init, [P])),
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
    stop ->
      ok;
    _ ->
      loop(P)
  end.

addStation(Name, Geo) ->
  monitor ! {self(), addStation, Name, Geo}.

addValue(Name, Time, Type, Result) ->
  monitor ! {self(), addValue, Name, Type, Time, Result}.

removeValue(Name, Time, Type) ->
  monitor ! {self(), removeValue, Name, Time, Type}.

getOneValue(Name, Time, Type ) ->
  monitor ! {self(), getOneValue, Name, Time, Type}.

getStationMean(Name, Type) ->
  monitor ! {self(), getStationMean, Name, Type}.

getStationMeanWithTime(Name, Type, Time) ->
  monitor ! {self(), getStationMeanWithTime, Name, Type, Time}.

getDailyMean(Time, Type) ->
 monitor ! {self(), getDailyMean, Time, Type}.

getMaximumGradientStation(Type) ->
  monitor ! {self(), getMaximumGradientStation, Type}.

stop()->
  monitor ! stop.

test() ->
  createMonitor(),
  addStation("Hello", {10,20}),
  addStation("Hello2", {30,40}),
  addValue("Hello2", 10, "PM12", 10),
  addValue("Hello2", 10, "PM25", 100),
  addValue("Hello", 11, "PM12", 10),
  addValue("Hello", 10, "PM12", 100).



