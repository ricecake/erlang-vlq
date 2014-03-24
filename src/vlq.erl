-module(vlq).

-export([encode/1, decode/1]).

encode(Integer) when is_integer(Integer) -> false;
encode(Binary) when is_binary(Binary) -> false;
encode(List)  when is_list(List) -> false.

decode(Binary) when is_binary(Binary) -> false;
decode(List)  when is_list(List) -> false.
