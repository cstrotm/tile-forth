.( Loading Sets test...) cr

#include blocks.f83
#include sets.f83

sets blocks

.( 1: Set elements return pointers to the entry) cr

: element ( -- )
  create last ,
does> ( element -- entry)
  @
;


.( 2: A simple destructive copying function for sets) cr

: copy-set ( set1 set2 -- )
  dup empty-set union-set
;


.( 3: Color elements and some sets for calculations) cr

element white
element black

element blue
element red
element yellow

element green
element brown
element violet

10 set colors

{ yellow red blue }    constant primary ( -- set)
{ green brown violet } constant secondary ( -- set)


.( 4: The set of sets and a set print function) cr

{ colors primary secondary } constant the-sets ( -- set)

: .sets ( -- )
  ." { "
  the-sets block[ execute .set ]; map-set
  ." } "
;

.sets cr

.( 5: Testing the symbol set management) cr


yellow colors add-set colors .set cr
secondary colors copy-set colors .set cr
brown colors remove-set colors .set cr

primary colors union-set colors .set cr
blue colors remove-set colors .set cr
{ red brown blue green yellow } colors intersection-set colors .set cr

forth only

