%%%-------------------------------------------------------------------
%%% @author jakubrog
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 06. Apr 2019 9:02 AM
%%%-------------------------------------------------------------------
-module(nowy).
-author("jakubrog").

%% API
-export([f/0, createAndAsk/0, reply/0, pass/0, pass/1, testTimes/0, start/0, stop/0, mul/1, loop/0]).

% Wyrażenie receive wstrzymuje wykonanie procesu do czasu dopasowania którejś z wiadomości do wzorca
% Wiadomości są dopasowywane do wzorców poczynając od najstarszej
% Jeśli wiadomość nie pasuje do żadnego wzorca, jest zwracana do kolejki

% do wysylanie wiadomości służy operator !: Pid ! hello, pid jest zwracany przez spawn

f() ->
  receive
    hello -> io:format("Hello");
    bye -> io:format("bye")
   % _ -> unknownMessage
  end.


%Aby odpowiedzieć trzeba znac pid nadawcy, dlatego najlepiej przekazac go w krotce
%Do pobrania wlasnego pid sluzy: self()

createAndAsk() ->
  Pid = spawn(nowy, reply, []),
  Pid ! {self(), question},  % tutaj podajemy swoj pid zeby drugi proces wiedzial gdzie ma odpowiedziec
  receive
    answer -> io:format("got the answer")
  end.

reply() ->
  receive
    {Pid, question} -> Pid ! answer
  end.




pass(Count) ->
  Pid = spawn(?MODULE, pass, []),  %?MODULE - returns the name of current module
  Pid ! {self(),Count}, % wysylam komunikat do funkjci pass/0
  receive
    _ -> io:format("Here2")
  end.


pass() ->
  receive
    {ParentPid, Count} when Count > 0 ->
      Pid = spawn(?MODULE, pass, []),
      io:format("Here~n"),
      Pid ! {self(),Count - 1},
      receive
        _ -> ParentPid ! ok
      end;
    {ParentPid,_} -> ParentPid ! ok
  end.

% Gdy kolejnosc przetwarzania nie ma znaczenia przetrzymujemy je wszystkie w jednym bloku receive. Gdy chcemy aby,
% kolejnosc miala znaczenie to definiujmy kilka blokow receive i im blok wyzej tym sie szybicej wykona
%np:
%receive
%   {msg1,Data} -> processMessage1(Data)
%end,
%receive
%   {msg2,Data} -> processMessage2(Data)
%end.

% Wyrażenie receive wstrzymuje wykonanie procesu do czasu dopasowania otrzymanej wiadomości
% Opcjonalnie może zakończyć się bez dopasowania po określonym czasie, wtedy wykonuje sie funckja cancelProcessing() i
% proces sie konczy

%%receive
%%  msg1-> processMsg1();
%%  msg2 -> processMsg2()
%%after
%%  1000 ->  cancelProcessing()
%%end

testTimes() ->
  receive
    ok -> io:format("osk");
    _ -> io:format("what?")
  after
    10000 -> io:format("3s~n")  % czas podany w milisekundach
  end.


% Nie odbieranie wiadomosci moze powodowac przepelnienie skrzynki, przez co operatorem flush() mozna ja wyczyscic


% register(alias, PID) - pozwala nadac nazwe alias do procesu pid = PID, wowczas kazdy moze mu wyslac wiadomosc
% uzywajac tego aliasu, inaczej tylko ten co tworzy zna jego pid zeby z nim cos robic

% registered() - zwraca zarejestowane procesy

% wheris(alias) - zwraca PID procesu pod aliasem alias


%%% WZORCE PROJEKTOWE I SERWERY

%%# 1. Serwer mnożący liczbę przez 3


start() ->
  register (m3server, spawn (?MODULE, loop, [])).

stop() ->
  m3server ! stop.

mul(N) ->
  m3server ! {self(), N},
  receive
    M ->  M
  end,
  io:format("Result: ~p~n", [M]).

loop() ->
  receive
    stop -> ok;
    {Pid, N} ->
      Result = N * 3,
      io:format("Server got ~w, returning ~w ~n", [N, Result]),
      Pid ! Result,
      nowy:loop()
  end.

loop() ->
  receive
    stop -> ok;
    {Pid, N} ->
      Result = N * 6,
      io:format("Server got ~w, returning ~w ~n", [N, Result]),
      Pid ! Result,
      nowy:loop()
  end.

%% Ogarniac od slajdu 40