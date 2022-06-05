-module(mult_test_SUITE).

-include_lib("stdlib/include/assert.hrl").
-include_lib("eunit/include/eunit.hrl").

base_test() ->
    A = [[1]],
    B = [[1]],
    C = [[1]],
    ABlock = erlBlas:matrix(A),
    BBlock = erlBlas:matrix(B),
    CBlock = erlBlas:matrix(C),
    Res = erlBlas:mult(ABlock, BBlock),
    ?assert(erlBlas:equals(Res, CBlock)).

max_size_blocks_test() ->
    A = [
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    ],

    B = [
        [2, 4, 6, 8, 10, 12, 14, 16, 18, 20],
        [2, 4, 6, 8, 10, 12, 14, 16, 18, 20],
        [2, 4, 6, 8, 10, 12, 14, 16, 18, 20],
        [2, 4, 6, 8, 10, 12, 14, 16, 18, 20],
        [2, 4, 6, 8, 10, 12, 14, 16, 18, 20],
        [2, 4, 6, 8, 10, 12, 14, 16, 18, 20],
        [2, 4, 6, 8, 10, 12, 14, 16, 18, 20],
        [2, 4, 6, 8, 10, 12, 14, 16, 18, 20],
        [2, 4, 6, 8, 10, 12, 14, 16, 18, 20],
        [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
    ],

    C = [
        [110, 220, 330, 440, 550, 660, 770, 880, 990, 1100],
        [110, 220, 330, 440, 550, 660, 770, 880, 990, 1100],
        [110, 220, 330, 440, 550, 660, 770, 880, 990, 1100],
        [110, 220, 330, 440, 550, 660, 770, 880, 990, 1100],
        [110, 220, 330, 440, 550, 660, 770, 880, 990, 1100],
        [110, 220, 330, 440, 550, 660, 770, 880, 990, 1100],
        [110, 220, 330, 440, 550, 660, 770, 880, 990, 1100],
        [110, 220, 330, 440, 550, 660, 770, 880, 990, 1100],
        [110, 220, 330, 440, 550, 660, 770, 880, 990, 1100],
        [110, 220, 330, 440, 550, 660, 770, 880, 990, 1100]
    ],

    ABlock = erlBlas:matrix(A),
    BBlock = erlBlas:matrix(B),
    CBlock = erlBlas:matrix(C),
    Res = erlBlas:mult(ABlock, BBlock),
    ?assert(erlBlas:equals(Res, CBlock)).

float_test() ->
    A = [[-1.2, 2.5, 3.6, 4.7, 5.69, 42.69], [6.24, 7.77, 8.42, -9.58, 10.013, 69.42]],

    B = [
        [1.2, 2.5],
        [3.6, 4.7],
        [-5.69, 42.69],
        [6.24, -7.77],
        [8.42, 9.58],
        [-10.013, 69.42]
    ],

    ABlock = erlBlas:matrix(A),
    BBlock = erlBlas:matrix(B),
    Res = erlBlas:mult(ABlock, BBlock),
    ANum = numerl:matrix(A),
    BNum = numerl:matrix(B),
    Conf = numerl:dot(ANum, BNum),
    Expected = numerl:mtfl(Conf),
    Actual = erlBlas:toErl(Res),
    ?assert(mat:'=='(Expected, Actual)).

small_random_test() ->
    erlBlas:set_max_length(50),
    Sizes = [rand:uniform(10), rand:uniform(10), rand:uniform(10)],
    {timeout, 100, fun() -> matrix_test_core(Sizes) end}.

corner_cases_test_() ->
    erlBlas:set_max_length(50),
    Sizes = [49, 50, 51, 99, 100, 101],
    {timeout, 100, fun() -> matrix_test_core(Sizes) end}.

random_test() ->
    erlBlas:set_max_length(50),
    Sizes = [rand:uniform(800) + 500, rand:uniform(800) + 500, rand:uniform(800) + 500],
    {timeout, 100, fun() -> matrix_test_core(Sizes) end}.

matrix_test_core(Sizes) ->
    lists:map(
        fun(K) ->
            lists:map(
                fun(M) ->
                    lists:map(
                        fun(N) ->
                            random_test_core(K, M, N)
                        end,
                        Sizes
                    )
                end,
                Sizes
            )
        end,
        Sizes
    ).

random_test_core(K, M, N) ->
    A = utils:generateRandMat(K, M),
    B = utils:generateRandMat(M, N),
    ABlock = erlBlas:matrix(A),
    BBlock = erlBlas:matrix(B),
    Res = erlBlas:mult(ABlock, BBlock),
    ANum = numerl:matrix(A),
    BNum = numerl:matrix(B),
    Conf = numerl:dot(ANum, BNum),
    Expected = numerl:mtfli(Conf),
    Actual = erlBlas:toErl(Res),
    ?assert(mat:'=='(Expected, Actual)).
