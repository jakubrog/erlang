%%%-------------------------------------------------------------------
%%% @author jakubrog
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. May 2019 18:57
%%%-------------------------------------------------------------------
-module(pollution).
-author("jakubrog").

%% API

%%%-------------------------------------------------------------------
%%% @author jakubrog
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 01. Apr 2019 10:00 AM
%%%-------------------------------------------------------------------

%% API
-export([crash/0, createMonitor/0, addStation/3, addValue/5, test/0, removeValue/4, getOneValue/4, getStationMean/3, getDailyMean/3, getMaximumGradientStation/2]).


createMonitor() ->
  #{stations => []}.


addStation(Name, Geo, Map) ->
  Station = #{name => Name, coord => Geo, results => []},
  maps:update(stations, [Station | maps:get(stations, Map)], Map).


addValue(Name, Time, Type, Result, P) ->
  Stations = maps:get(stations, P),
  [Station | _] =  [X || X <- Stations, maps:get(name, X) == Name],
  Measure = #{type=>Type, time=> Time, result=> Result},
  Updated = maps:update(results, [Measure | maps:get(results, Station)], Station),
  NewStations = lists:delete(Station, Stations),
  maps:update(stations, [Updated | NewStations], P).

removeValue(Name, Time, Type, P) ->
  Stations = maps:get(stations, P),
  [Station | _] =  [X || X <- Stations, maps:get(name, X) == Name],
  Results = maps:get(results,Station),
  [ToDelete | _] = [X || X<-Results, maps:get(time, X) == Time, maps:get(type, X) == Type],
  NewResults = lists:delete(ToDelete, Results),
  Updated = maps:update(results, NewResults, Station),
  NewStations = lists:delete(Station, Stations),
  maps:update(stations, [Updated | NewStations], P).


%getOneValue/4 - zwraca wartość pomiaru o zadanym typie, z zadanej daty i stacji;
getOneValue(Name, Time, Type, P) ->
  Stations = maps:get(stations, P),
  [Station | _] =  [X || X <- Stations, maps:get(name, X) == Name, maps:get(type, X) == Type],
  Results = maps:get(results,Station),
  [Result | _] = [X || X<-Results, maps:get(time, X) == Time],%Add rest
  maps:get(result, Result).


%getStationMean/3 - zwraca średnią wartość parametru danego typu z zadanej stacji;
getStationMean(Name, Type, P) ->
  Stations = maps:get(stations, P),
  [Station | _] =  [X || X <- Stations, maps:get(name, X) == Name],
  Results = maps:get(results,Station),
  Result = [X || X<-Results, maps:get(type, X) == Type],
  Length = length(Result),
  Sum = lists:map(fun (X) -> maps:get(result, X) end, Result),
  if
    Length > 0 ->
      lists:sum(Sum) / Length;
    true ->
      0
  end.

getStationMeanWithTime(Name, Type, Time,  P) ->
  Stations = maps:get(stations, P),
  [Station | _] =  [X || X <- Stations, maps:get(name, X) == Name],
  Results = maps:get(results,Station),
  Result = [X || X<-Results, maps:get(type, X) == Type, maps:get(time, X) == Time],%Add rest
  Length = length(Result),
  Sum = lists:map(fun (X) -> maps:get(result, X) end, Result),
  if
    Length > 0 ->
      lists:sum(Sum) / Length;
    true ->
      0
  end.

getDailyMean(Time, Type , P) ->
  Stations = maps:get(stations, P),
  Result = [getStationMeanWithTime(maps:get(name, X), Type, Time, P) || X <- Stations],
  Result2 = lists:filter(fun (X) -> X =/= 0 end, Result),
  Length = length(Result2),
  if
    Length > 0 ->
      lists:sum(Result2) / Length;
    true ->
      0
  end.

getGradient(Station, Type)->
  Results = maps:get(results, Station),
  Values = [maps:get(result, X) || X<-Results, maps:get(type, X) == Type],
  Length = length(Values),
  if
    Length > 0 ->
      [H | T] = lists:sort(Values),
      lists:last([H|T]) - H;
    true -> 0
  end.


getMaximumGradientStation(Type, P) ->
  Stations = maps:get(stations, P),
  Gradients = [{getGradient(X, Type), X} || X <- Stations],
  {_, Result} = lists:max(Gradients),
  Result.

crash() ->
  1/0.


test() ->
  P = createMonitor(),
  P1 = addStation("Hello", {10,20}, P),
  P2 = addStation("Hello2", {30,40}, P1),
  P3 = pollution:addValue("Hello2", 10, "PM12", 10, P2),
  P4 = pollution:addValue("Hello2", 10, "PM25", 100, P3),
  P5 = pollution:addValue("Hello", 11, "PM12", 10, P4),
  P6 = pollution:addValue("Hello", 10, "PM12", 100, P5).


