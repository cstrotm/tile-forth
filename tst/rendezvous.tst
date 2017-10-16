.( Loading Multi-tasking rendezvous test...) cr

#include multi-tasking.f83

multi-tasking 

.( 1: A simple server task that performs the service one-plus) cr

RENDEZVOUS service ( n -- m)

16 16 task.type SERVER
task.body
  begin
    accept service ( arg -- res)
      1+
    accept.end
  again
task.end

SERVER aServer


.( 2: A multiple read buffer with services put and get) cr

RENDEZVOUS put ( n -- nil)
RENDEZVOUS get ( nil -- n)

16 16 task.type BUFFER
  long item
task.body
  accept put ( item -- nil)
    item ! nil
  accept.end
  begin
    ?awaiting put if
      accept put ( item -- nil)
	item ! nil
      accept.end
    then
    ?awaiting get if
      accept get ( nil -- item)
	drop item @
      accept.end
    then
    detach
  again
task.end

BUFFER aBuffer


.( 3: A demon task which feed the two other tasks with calls) cr

16 16 task.type DEMON
task.body
  begin
    nil get service put drop
  again
task.end

DEMON aDemon


.( 4: Initiate the buffer and run the scenario) cr

0 put drop 10000 delay 0 get . cr

forth only
