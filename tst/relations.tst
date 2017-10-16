.( Loading Relations test...) cr

#include relations.f83
#include blocks.f83

string blocks relations

.( 1: Some simple items and relations between them) cr

item a
item b
item c
item d
.items cr

10 a a put-relation
11 b a put-relation
12 c a put-relation
13 d a put-relation

a .relations cr
b .relations cr
c .relations cr
d .relations cr
a .values cr

a a remove-relation
a .values cr

d a remove-relation
a .values cr

item Joe
item address
item profession

" Forth road 4, Forthiana" address Joe put-relation
" Forth Hacker" profession Joe put-relation
Joe .values cr
cr

.( 2: Reflexive and symmetric relations) cr

: reflexive ( relation item -- )
  tuck put-relation
;

: symmetric ( item1 relation item2 -- )
  >r 2dup r@ put-relation
  r> swap rot put-relation
;

.( 3: Directions and opposite directions) cr

item north
item south
item east
item west
item opposite
.items cr

north opposite south symmetric
east  opposite west  symmetric

opposite block[ ( value item -- ) 
  .item space opposite .item space .item cr
]; map-relation
cr

.( 4: A small map with locations and paths) cr

: location ( -- )
  item
;

: path ( from direction to -- )
  >r 2dup r@ put-relation
  opposite swap get-relation
  r> swap rot put-relation
;

location HardwareShop
location Macdonalds
location Drugstore
location Hotel
.items cr

Hotel west HardwareShop path
Macdonalds south Hotel path
Drugstore west Macdonalds path
Hotel east Hotel path

Hotel .relations cr
Macdonalds .relations cr
HardwareShop .relations cr
Drugstore .relations cr
cr

.( 5: Sets, Bags and Dictionaries using relations) cr

: occurencesOf ( element set -- value)
  ?get-relation not if 2drop 0 then
;

: ?includes ( element set -- flag)
  occurencesOf boolean
;  

: add ( element set -- )
  1 -rot put-relation
;

: remove ( element set -- )
  remove-relation
;

: addWithOccurrences ( value element bag -- )
  2dup 2>r occurencesOf + 2r> put-relation
;

item x
item aSet
item aBag
item aDictionary
.items cr

x aSet ?includes .
x aSet add
x aSet ?includes .
x aSet remove
10 x aBag addWithOccurrences
x aBag occurencesOf .
10 x aBag addWithOccurrences
x aBag occurencesOf .
x aBag remove
x aBag occurencesOf .
x aDictionary ?includes .
100 x aDictionary put-relation
x aDictionary get-relation . cr
aSet .relations cr
aBag .relations cr
aDictionary .relations cr
cr

.( 6: Item relation database dump example) cr

item dump

item is-an-item

is-an-item dump dump put-relation
is-an-item dump north put-relation
is-an-item dump west put-relation
is-an-item dump south put-relation
is-an-item dump east put-relation
is-an-item dump opposite put-relation

item is-a-string

is-a-string dump address put-relation
is-a-string dump profession put-relation

: dump-items ( -- )
  block[ ( item -- )
    ." item " .item cr
  ];
  map-items
;  

: dump-item-values ( -- )
  block[ ( item -- )
    dup
    block[ ( item value attribute -- item)
      tuck dump swap ?get-relation
      if
	case
	  is-an-item of .item space endof
	  is-a-string of ascii " emit space $print ascii " emit space endof
	  swap .
	endcase
      else
	2drop .
      then
      .item space dup .item space ." put-relation" cr
    ];
    map-item 
    drop
  ];
  map-items
;

\ Dump the current set of items and their values in a loadable form

dump-items cr
dump-item-values cr
cr

forth only

