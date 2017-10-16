.( Loading Queues test...) cr

#include queues.f83
#include blocks.f83

blocks queues definitions

: print-queue ( queue -- )
  block[ . ]; map-queue
;

.( 1: Create a queue and insert some elements) cr

QUEUE foo ( -- queue)
foo print-queue
foo ?empty-queue .
foo size-queue . cr

QUEUE fie ( -- queue)
fie foo enqueue
foo print-queue
foo ?empty-queue .
foo size-queue . cr

QUEUE fum ( -- queue)
fum foo enqueue
foo print-queue
foo ?empty-queue .
foo size-queue . cr


.( 2: Print information about all the queue elements) cr

foo block[ .queue cr ]; map-queue


.( 3: Remove some queue elements) cr

fie dequeue foo .queue cr
fum dequeue foo .queue cr


.( 4: Try the member function) cr

foo foo ?member-queue .
fie foo ?member-queue .
fie foo enqueue 
fie foo ?member-queue . cr

forth only

