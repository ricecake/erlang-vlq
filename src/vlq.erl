-module(vlq).

-export([encode/1, decode/1]).

encode(Integer) when is_integer(Integer) -> doEncode(binary:encode_unsigned(Integer), <<>>);
encode(Binary) when is_binary(Binary) -> doEncode(Binary, <<>>);
encode(List)  when is_list(List) -> Encoded = [encode(Item) || Item <- List], lists:foldl(fun(Item, Acc)-> <<Acc/bits, Item/bits>> end, <<>>, Encoded).

decode(Binary) when is_binary(Binary) -> false;
decode(List)  when is_list(List) -> false.


%%%%%%%%%%%%%% Private Methods %%%%%%%%%%%%%%%%%%%

doEncode(Binary, Accum) -> List = chunk(Binary, []), mark(List, Accum).

mark([Last], Accum) -> << Accum/bitstring, 0:1, Last:7/bitstring >>;
mark([<<0:7>> | Rest], Accum) -> mark(Rest, Accum);
mark([Item | Rest], Accum) -> mark(Rest, << Accum/bits, 1:1, Item:7/bitstring >>).

chunk(<<>>, Accum) -> Accum;
chunk(Binary, Accum) when bit_size(Binary) rem 7 /= 0 -> chunk(pad_bits(left, 7, Binary), Accum);
chunk(Binary, Accum) -> 
	Size = bit_size(Binary)-7, 
	<<Rest:Size/bitstring, Term:7/bitstring>> = Binary, 
	chunk(Rest, [Term | Accum]).

pad_bits(_,Width,Binary) when bit_size(Binary) rem Width =:= 0 -> Binary;
pad_bits(left,Width,Binary) -> <<0:(Width - (bit_size(Binary) rem Width)),Binary/bitstring>>;
pad_bits(right,Width,Binary) -> <<Binary/bitstring,0:(Width - (bit_size(Binary) rem Width))>>.
