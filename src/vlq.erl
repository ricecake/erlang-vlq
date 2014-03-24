-module(vlq).

-export([encode/1, decode/1, test/2]).

encode(Integer) when is_integer(Integer) -> doEncode(<<Integer>>, <<>>);
encode(Binary) when is_binary(Binary) -> doEncode(Binary, <<>>);
encode(List)  when is_list(List) -> false.

decode(Binary) when is_binary(Binary) -> false;
decode(List)  when is_list(List) -> false.


%%%%%%%%%%%%%% Private Methods %%%%%%%%%%%%%%%%%%%

test(<<>>, Accum) -> Accum;
test(Binary, Accum) when bit_size(Binary) > 6 -> io:format("~p~n",[{Binary, bit_size(Binary), Accum}]), Size = bit_size(Binary)-7, <<Rest:Size/bitstring, Term:7/bitstring>> = Binary, test(Rest, [Term | Accum]);
test(Binary, Accum) when bit_size(Binary) < 7 -> 
	Size = 7-bit_size(Binary), 
	io:format("~p~n",[{Binary, Size, Accum}]), 
	test(<<>>, [<<0:Size/bitstring, Binary/bitstring>>|Accum]).

%doEncode(<<Term:7/bitstring, Rest/bitstring>>, <<>>) -> io:format("~p~n",[{Term, Rest}]).

doEncode(<<>>, Binary) -> Binary;
doEncode(<<0:8/bitstring,    Rest/bitstring>>, <<>>)  -> doEncode(Rest/bitstring, <<>>);
doEncode(<<0:1/bitstring, Term:7/bitstring, Rest/bitstring>>, <<>>)  -> doEncode(Rest/bitstring, <<1:1, Term:7/bitstring>>);
doEncode(<<Term:7/bitstring>>, Binary)  -> <<Binary/bitstring, 0:1, Term:7/bitstring>>;
doEncode(<<Term:7/bitstring, Rest/bitstring>>, <<>>)  -> doEncode(Rest, <<1:1, Term:7/bitstring>>);
doEncode(<<Term:7/bitstring, Rest/bitstring>>, Accum) -> doEncode(Rest, <<Accum/bitstring, 0:1, Term:7/bitstring>>).
