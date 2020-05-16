trie_test() ->
    trie_test(33000, #{tot => 0}).
trie_test(0, Trie) -> Trie;
trie_test(N, Trie) ->
    Rand = integer_to_list(random_int(1, 999999)),
    trie_test(N - 1, build_trie(Rand, 0, Trie)).

build_trie(Word) -> build_trie(Word, 0, #{tot => 0}).
build_trie([], Index, Trie) ->
    CurNode = maps:get(Index, Trie, #{next => #{}, v => 0}),
    Trie#{Index => CurNode#{v => 0}};
build_trie([H | T], Index, Trie) ->
    Tot = maps:get(tot, Trie),
    CurNode = maps:get(Index, Trie, #{next => #{}, v => 0}),
    NextNode = maps:get(next, CurNode, #{}),
    Next = maps:get(H, NextNode, 0),
    {NewNum, NewTrie} =
        case Next of
            0 ->
                TempNode = maps:get(Tot + 1, Trie, #{next => #{}, v => 0}),
                Trie1 = Trie#{Tot + 1 => TempNode#{v => -1}},
                CurNodeNext = maps:get(next, CurNode, #{}),
                {Tot + 1, Trie1#{Index => CurNode#{next => CurNodeNext#{H => Tot + 1}}}};
            Num -> {Num, Trie}
        end,
    build_trie(T, NewNum, NewTrie#{tot => Tot + 1}).

query_trie(Word, Trie) -> query_trie(Word, 0, 0, Trie).
query_trie(_, _, -1, _) -> -1;
query_trie([], Index, _Exist, Trie) ->
    #{v := V} = maps:get(Index, Trie, #{next => #{}, v => 0}), V;
query_trie([H | T], Index, _Exist, Trie) ->
    CurNode = maps:get(Index, Trie, #{next => #{}, v => 0}),
    NextNode = maps:get(next, CurNode, #{}),
    Next = maps:get(H, NextNode, 0),
    case Next of
        0 -> query_trie(T, Next, -1, Trie);
        _ -> query_trie(T, Next, 0, Trie)
    end.