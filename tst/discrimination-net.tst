.( Loading Discrimination Net test...) cr

#include relations.f83
#include blocks.f83

string blocks relations forth definitions

\ Discrimination tree interpreter

item question

: ?question ( node -- node addr)
  question over ?get-relation not if 2drop nil then
;

: .question ( question -- )
  $print space
;

: .relations ( node -- )
  ." One of the following:" cr
  block[ ( value relation -- )
    dup question = if drop else .item space then drop
  ]; map-item
;

: ?scan-relation ( node1 -- [node2 true] or [node1 false])
  32 word find 
  if >body swap ?get-relation dup not
    if drop nip false then
  else
    drop false
  then
;

: discriminate ( node -- item)
  begin
    ?question ?dup
  while
    .question ?scan-relation not
    if dup .relations cr then
  repeat
;


\ A Garden-variety discrimination tree
\ From E. Charniak, et al., Aritificial Intelligence Programming,
\ Chap. 8 Simple Discrimination Nets, pp. 153.

item node#1
item node#2
item node#3
item node#4
item node#5

item red
item green
item yellow

item round
item cylindrical
item flat

item small
item medium
item large

item TOMATO
item PEAS
item BRUSSEL-SPROUTS
item GREEN-BEANS
item ASPARAGUS
item SPINACH
item WAX-BEANS
item YELLOW-SQUASH

\ Build the Garden-variety discrimination tree

" What color is it?" question node#1 put-relation
TOMATO red node#1 put-relation
node#2 green node#1 put-relation
node#3 yellow node#1 put-relation

" What shape is it?" question node#2 put-relation
node#4 round node#2 put-relation
node#5 cylindrical node#2 put-relation
SPINACH flat node#2 put-relation

" What size is it?" question node#3 put-relation
WAX-BEANS medium node#3 put-relation
YELLOW-SQUASH large node#3 put-relation

" What size is it?" question node#4 put-relation
PEAS small node#4 put-relation
BRUSSEL-SPROUTS medium node#4 put-relation

" What size is it?" question node#5 put-relation
GREEN-BEANS small node#5 put-relation
ASPARAGUS large node#5 put-relation

\ The Garden-variety help 

: plant-help ( -- )
  node#1 discriminate ." The plant is a " .item cr
;


\ Discrimination net from BABEL 

item node#1
item node#2
item node#3
item node#4
item node#5
item node#6
item node#7

item yes
item no

item INGEST
item EAT
item DRINK
item INHALE
item BREATHE
item TAKE
item SMOKE

" Is the thing ingested a medicine?" question node#1 put-relation
node#2 no node#1 put-relation
TAKE yes node#1 put-relation

" Is it a gas?" question node#2 put-relation
node#3 no node#2 put-relation
node#4 yes node#2 put-relation

" Is it a fluid?" question node#3 put-relation
node#5 no node#3 put-relation
node#6 yes node#3 put-relation

" Is it something used for smoking?" question node#4 put-relation
node#7 no node#4 put-relation
SMOKE yes node#4 put-relation

" Is it ingested via the mouth?" question node#5 put-relation
INGEST no node#5 put-relation
EAT yes node#5 put-relation

" Is it alcohol?" question node#6 put-relation
DRINK no node#6 put-relation
DRINK yes node#6 put-relation

" Is it air?" question node#7 put-relation
INHALE no node#7 put-relation
BREATHE yes node#7 put-relation

: babel ( -- )
  node#1 discriminate ." Use the word " .item cr
;

forth only
