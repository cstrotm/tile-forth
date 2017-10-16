.( Loading Prototypes test...) cr

#include prototypes.f83

string prototypes forth definitions

.( 1: Define the forward declared error handling as messages) cr


nil prototype Object ( -- prototype)

message write ( self -- )

Object method unknown-message ( message self -- )
  .prototype space ." has no method for " .message cr abort
;

Object method unknown-slot ( slot self -- )
  .prototype space ." has no slot named " .slot cr abort
;

Object method write ( self -- )
  ." Object#" .
;

Object write cr
Object .relations cr
cr

.( 3: Create a prototype for points) cr

Object prototype Point

slot x: ( self -- value)
slot y: ( self -- value)

message position ( x y self -- )
message where ( self -- x y)

Point method write ( self -- )
  ." Point#" dup . ." x: " dup x: . ." y: " y: .
;

Point method position ( x y self -- )
  tuck -> y: -> x:
;

Point method where ( self -- x y)
  dup x: swap y:
;

0 0 Point position
Point write cr
Point .relations cr
cr

.( 4: Show the error handling when a slot or method is missing) cr

Object x:
Object position

cr

.( 5: Show different levels of data sharing through inheritance) cr

Point prototype aPoint 

aPoint .relations cr
1 aPoint -> x:
aPoint .relations cr
aPoint write cr
aPoint x: 1+ aPoint -> x:
aPoint write cr
aPoint x: 2- aPoint -> y:
aPoint write cr
cr

.( 6: The classical account example in prototype fashion) cr

Object prototype Account

message open ( name self -- )
message deposit ( money self -- )
message withdraw ( money self -- )

slot owner: ( self -- value)
slot balance: ( self -- value)

0 Account -> balance:

Account method open ( owner self -- )
  -> owner:
;

Account method deposit ( money self -- )
  tuck balance: + swap -> balance:
;

Account method withdraw ( money self -- )
  tuck balance: swap - swap -> balance:
;

Account method write ( self -- )
  ." Account#" dup . ." owner: " dup owner: $print ."  balance: " balance: .
;

Account .relations cr
cr

.( 7: Create an account and deposit and withdraw some money) cr

Account prototype anAccount
" Mikael" anAccount open
anAccount write cr
100 anAccount deposit
anAccount write cr
98 anAccount withdraw
anAccount balance: . cr
cr

.( 8: More error message testing) cr

anAccount x:
anAccount position

forth only

