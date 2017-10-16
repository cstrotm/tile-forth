.( Loading Objects test...) cr

#include objects.f83

objects string forth definitions


\ The set of messages needed for this example

message initiate ( self -- )

message isKindOf ( class self -- boolean)
message isMemberOf ( class self -- boolean)
message respondsTo ( message self -- boolean)

message instanceSize ( self -- num)
message copy ( self -- object)
message shallowCopy ( self -- object)
message deepCopy ( self -- object)

message doesNotUnderstand ( message self -- )
message subclassResponsibility ( self -- )
message shouldNotImplement ( self -- )

message perform ( message self -- )

message basicWrite ( self -- )
message write ( self -- )
message read ( self -- )

message where ( self -- x y)
message position ( x y self -- )

message balance ( self -- x)
message owner ( self -- x)
message deposit ( x self -- )
message withdraw ( x self -- )
message balance ( self -- x)


\ A class hierarchy with Object, Point, and Account

nil subclass Object ( -- )

method initiate ( self -- )
  basicWrite ." initiated" cr
;

method isKindOf ( class self -- bool)
  class
  begin
    2dup =
    if 2drop true exit then
    superclass dup 0=
  until
  2drop false
;

method isMemberOf ( class self -- bool)
  class =
;

method respondsTo ( message self -- bool)
  class canUnderstand
;

method instanceSize ( self -- num)
  class basicInstanceSize
;

method copy ( self -- object) 
  shallowCopy
;

method shallowCopy ( self -- object)
  here swap 2dup instanceSize dup allot cmove
;

method deepCopy ( self -- object)
  copy
;

method doesNotUnderstand ( message self -- )
  basicWrite ." does not understand: " .message cr abort
;

method subclassResponsibility ( message self -- )
  basicWrite ." subclass should have overridden: " .message cr abort
;

method shouldNotImplement ( message self -- )
  basicWrite ." should not implement: " .message cr abort
;

method perform ( message self -- )
  tuck class send
;
  
method write ( self -- )
  basicWrite
;

method basicWrite ( self -- )
  dup .class ." #" .
;

subclass.end


Object subclass Point ( x y -- )

  long +x ( self -- addr)
  long +y ( self -- addr)

method initiate ( x y self -- )
  dup >r super initiate r> position
;

method position ( x y self -- )
  tuck +y ! +x ! 
;

method where ( self -- x y)
  dup +x @ swap +y @
;

method write ( self -- )
  dup super write where ." x: " swap . ." :y " .
;

subclass.end


Object subclass Account ( x -- )

  long +owner ( self -- addr)
  long +balance ( self -- addr)

method initiate ( x self -- )
  dup >r super initiate r>
  0 over +balance ! +owner !
;

method balance ( self -- x)
  +balance @
;

method owner ( self -- x)
  +owner @
;

method deposit ( x self -- )
  +balance +!
;

method withdraw ( money self -- )
  swap negate swap +balance +!
;

method write ( self -- )
  dup super write
  ." owner: " dup owner $print space
  ." balance: " balance .
;

subclass.end

: DEBUG ;

#ifdef DEBUG

message traceOn ( self  -- )
message traceOff ( self -- )

nil subclass TraceableObject ( class -- )

  ptr +real-object ( self -- addr)
  long +traced ( self -- addr)

method initiate ( class self -- )
  >r new-instance r@ +real-object ! r> traceOff
;

method doesNotUnderstand ( message self -- )
  dup +traced @
  if 2dup +real-object @
    basicWrite ." called with the message: " .message cr
  then
  +real-object @ tuck class send
;

method traceOff ( self -- )
  false swap +traced !
;

method traceOn ( self -- )
  true swap +traced !
;

subclass.end

#else

: TraceableObject ( -- ) ;
: traceOff ( self -- ) drop ;
: traceOn ( self -- ) drop ;

#then


\ Create some objects and send them a message or two

Object instance anObject
anObject write cr
anObject read
cr

10 10 Point instance aPoint
aPoint write cr
-10 -10 aPoint position
aPoint write cr
aPoint read 
cr

" Mikael" Account instance anAccount 
anAccount write cr
100 anAccount deposit
anAccount write cr
98 anAccount withdraw
anAccount write cr
cr


\ Demonstrate a traceable object class (a proxy class)

10 10 Point TraceableObject instance aTracedPoint
aTracedPoint traceOn
aTracedPoint write cr
-10 -10 aTracedPoint position
aTracedPoint write cr
aTracedPoint read
cr 

forth only

