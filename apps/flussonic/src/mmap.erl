%%% @author     Max Lapshin <max@maxidoors.ru> [http://erlyvideo.org]
%%% @copyright  2010-2012 Max Lapshin
%%% @doc        MMAP module
%%% @reference  See <a href="http://erlyvideo.org/" target="_top">http://erlyvideo.org/</a> for more information
%%% @end
%%%
%%% You are free to use this source in any ways.
%%% 
%%%---------------------------------------------------------------------------------------
-module(mmap).
-author('Max Lapshin <max@maxidoors.ru>').
-on_load(init_nif/0).


-export([init_nif/0, open/2, pread/3]).

-export([mmap_open/2, mmap_pread/3]).

-include("log.hrl").
-define(NIF_STUB, erlang:error({nif_stub, "MMAP nif wasn't loaded"})).



init_nif() ->
  Load = erlang:load_nif(code:lib_dir(flussonic,priv)++ "/mmap", 0),
  io:format("Load mmap: ~p~n", [Load]),
  ok.


open(Path, Options) when is_list(Path) ->
  open(list_to_binary(Path), Options);

open(Path, Options) when is_binary(Path) ->
  mmap_open(Path, Options).
  
mmap_open(_Path, _Options) ->
  ?NIF_STUB.
  

pread(File, Position, Size) when Position >= 0 andalso Position < size(File) ->
  case File of
    <<_:Position/binary, Bin:Size/binary, _/binary>> -> {ok, Bin};
    <<_:Position/binary, Bin/binary>> -> {ok, Bin}
  end;

pread(_File, Position, Size) when Position < 0 orelse Size < 0 ->
  {error,einval};

pread(File, Position, _Size) when Position >= size(File) ->
  eof.
  
mmap_pread(_File, _Position, _Size) ->
  ?NIF_STUB.
