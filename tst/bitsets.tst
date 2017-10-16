.( Loading Bitsets test...) cr

#include blocks.f83
#include bitsets.f83

bitsets blocks

bitset.type COLORS ( -- )
  item white ( -- item)
  item black ( -- item)
  item blue ( -- item)
  item red ( -- item)
  item yellow ( -- item)
  item green ( -- item)
  item brown ( -- item)
  item violet ( -- item)
bitset.end

COLORS colors ( -- addr)

{ yellow red blue }    constant primary
{ green brown violet } constant secondary

secondary .bitset COLORS cr

yellow empty-bitset add-bitset dup .bitset COLORS cr
green swap add-bitset .bitset COLORS cr
brown secondary remove-bitset .bitset COLORS cr

primary secondary union-bitset .bitset COLORS cr
blue primary remove-bitset .bitset COLORS cr

{ brown blue yellow } primary intersection-bitset .bitset COLORS cr

forth only
