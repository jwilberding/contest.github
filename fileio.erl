-module(fileio).
-export([read_data/1]).

read_data(Filename) ->
    io:format("Reading ~s~n", [Filename]),
    DataList = readlines(Filename),
    PData = lists:keysort(1,process_data(DataList)),
    %% check for dupes later..
    io:format("Head of PD: ~p~n", [hd(PData)]).

process_data(L) -> process_data(L, []).
process_data([], Acc) -> Acc;
process_data([H | T], Acc) ->
    [N1, N2] = string:tokens(string:strip(H, right, $\n), ":"),
    process_data(T, [{list_to_integer(N1), list_to_integer(N2)} | Acc]).

readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    get_all_lines(Device, []).

get_all_lines(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), lists:reverse(Accum);
        Line -> get_all_lines(Device, [Line|Accum])
    end.
