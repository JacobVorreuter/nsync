%% Copyright (c) 2011 Jacob Vorreuter <jacob.vorreuter@gmail.com>
%% 
%% Permission is hereby granted, free of charge, to any person
%% obtaining a copy of this software and associated documentation
%% files (the "Software"), to deal in the Software without
%% restriction, including without limitation the rights to use,
%% copy, modify, merge, publish, distribute, sublicense, and/or sell
%% copies of the Software, and to permit persons to whom the
%% Software is furnished to do so, subject to the following
%% conditions:
%% 
%% The above copyright notice and this permission notice shall be
%% included in all copies or substantial portions of the Software.
%% 
%% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
%% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
%% OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
%% NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
%% HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
%% WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
%% FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
%% OTHER DEALINGS IN THE SOFTWARE.
-module(nsync_list).
-export([command_hooks/0, handle/3]).

command_hooks() ->
    ["lpush", "lpop", "lrem", "rpush", "rpop"].

handle("lpush", [Key, Val], Tid) ->
    List = lookup(Tid, Key),
    ets:insert(Tid, {Key, [Val|List]});

handle("lpop", [Key], Tid) ->
    case ets:lookup(Tid, Key) of
        [{Key, [_Pop|Tail]}] ->
            ets:insert(Tid, {Key, Tail});
        _ ->
            ok
    end;

handle("lrem", [Key, Count, Val], Tid) ->
    List = lookup(Tid, Key),
    ets:insert(Tid, {Key, delete(Val, list_to_integer(binary_to_list(Count)), List)});

handle("rpush", [Key, Val], Tid) ->
    List = lookup(Tid, Key),
    ets:insert(Tid, {Key, List ++ [Val]});

handle("rpop", [Key], Tid) ->
    case lists:reverse(lookup(Tid, Key)) of
        [_Pop|Tail] ->
            ets:insert(Tid, {Key, lists:reverse(Tail)});
        [] ->
            ok
    end.

lookup(Tid, Key) ->
    case ets:lookup(Tid, Key) of
        [{Key, List}] -> List;
        [] -> []
    end.

delete(Elem, Count, List) when Count > 0 ->
    delete(Elem, Count, List, [], 0);
delete(Elem, Count, List) when Count < 0 ->
    lists:reverse(delete(Elem, Count * -1, lists:reverse(List), [], 0));
delete(Elem, _Count, List) ->
    delete(Elem, all, List, [], 0).

delete(_Elem, _Max, [], Acc, _Inc) ->
    lists:reverse(Acc);
delete(_Elem, Max, List, Acc, Max) ->
    lists:reverse(Acc) ++ List;
delete(Elem, Max, [Elem | T], Acc, Inc) ->
    delete(Elem, Max, T, Acc, Inc + 1);
delete(Elem, Max, [H | T], Acc, Inc) ->
    delete(Elem, Max, T, [H | Acc], Inc).

    
