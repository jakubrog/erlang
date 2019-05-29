%%%-------------------------------------------------------------------
%%% @author jakubrog
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 08. May 2019 14:06
%%%-------------------------------------------------------------------
-module(pollution_gen_server).
-author("jakubrog").
-behaviour(gen_server).
%% API
-export([crash/0, addStation/2, addValue/4, removeValue/3, getOneValue/3, getStationMean/2,
  getStationMeanWithTime/3, getDailyMean/2, start/0, stop/0]).
-export([init/1, start_link/0, handle_call/3, terminate/2, show/0]).
-export([handle_cast/2, handle_info/2]).



start_link() ->
  gen_server:start_link(
    {local,pollution_gen_server},
    pollution_gen_server,
    [], []).

init(InitialValue) ->
  {ok, pollution:createMonitor()}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%api
start()->
  start_link().

stop() ->
  gen_server:call(self(),terminate).

addStation(Name, Geo)->
  gen_server:call(?MODULE, {addStation, Name, Geo, [], [], []}).

addValue(Name, Time, Type, Result)->
  gen_server:call(?MODULE, {addValue, Name, [], Time, Type, Result}).

removeValue(Name, Time, Type) ->
  gen_server:call(?MODULE, {removeValue, Name, [], Time, Type, []}).

getOneValue(Name, Time, Type) ->
  gen_server:call(?MODULE, {getOneValue, Name, [], Time, Type,[]}).

getStationMean(Name, Type)->
  gen_server:call(?MODULE,{getStationMean, Name, [], [], Type, []}).

getStationMeanWithTime(Name ,Time, Type)->
  gen_server:call(?MODULE,{getStationMeanWithTime, Name, [], Time, Type, []}).

getDailyMean(Time, Type)->
  gen_server:call(?MODULE,{getDailyMean, [], [], Time, Type,[]}).


show()->
  gen_server:call(?MODULE,show).

crash()->
  gen_server:call(?MODULE,crash).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

handle_call({addStation, Name, Coords, _, _, _}, From, LoopData) ->
  P = pollution:addStation(Name, Coords, LoopData),
  {reply, P, P};

handle_call({addValue, Name, _, Time, Type, Result}, From, LoopData) ->
  P = pollution:addValue(Name, Time, Type, Result, LoopData),
  {reply, P, P};

handle_call({removeValue, Name, _, Time, Type, _}, From, LoopData) ->
  P = pollution:removeValue(Name, Time, Type, LoopData),
  {reply, P, P};


handle_call({getOneValue, Name, _, Time, Type, _}, From, LoopData) ->
  P = pollution:getOneValue(Name, Time, Type, LoopData),
  {reply, P, P};


handle_call({getStationMean, Name, _, _, Type, _}, From, LoopData) ->
  P = pollution:getStationMean(Name, Type, LoopData),
  {reply, P, P};


handle_call({getStationMeanWithTime, Name, _, Time, Type, _}, From, LoopData) ->
  P = pollution:getStationMeanWithTime(Name, Type, Time,  LoopData),
  {reply, P, P};


handle_call({getDailyMean, _, _, Time, Type, _}, From, LoopData) ->
  P = pollution:getDailyMean(Time, Type , LoopData),
  {reply, P, P};

handle_call(show, From, LoopData) ->
  {reply, LoopData, LoopData};

handle_call(crash, From, LoopData) ->
  pollution:crash(),
  {reply, LoopData, LoopData}.

handle_info({'EXIT', Pid, Reason}, State) ->
  {noreply, State}.

handle_cast({free, Ch}, Chs) ->
  {noreply, Chs}.

terminate(Reason, Value) ->
  io:format("Server: exit with value ~p~n", [Value]),
  Reason.