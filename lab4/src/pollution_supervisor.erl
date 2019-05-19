%%%-------------------------------------------------------------------
%%% @author jakubrog
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. May 2019 10:44
%%%-------------------------------------------------------------------
-module(pollution_supervisor).
-author("jakubrog").

-behaviour(supervisor).
%% API
-export([start_link/0, init/1]).

start_link() ->
  supervisor:start_link(?MODULE, []).

init(_Args) ->
  SupFlags = #{strategy => one_for_one, intensity => 1, period => 5},
  ChildSpecs = [#{id => pollution_gen_server,
    start => {pollution_gen_server, start_link, []}}],
  {ok, {SupFlags, ChildSpecs}}.