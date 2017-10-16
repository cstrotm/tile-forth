.( Loading Multi-tasking semaphore test...) cr

#include multi-tasking.f83

.( *** start of multi-tasking demo ***) cr

multi-tasking 

0 SEMAPHORE synch 

16 16 task.type TASK-1
task.body
  ." ** t1 waiting **" cr
  synch wait
  ." ** t1 terminated **" cr
task.end

.( ** t1 scheduled **) cr
TASK-1 t1
who cr
t1 .task cr

16 16 task.type TASK-2
task.body
  20 0 do
    100 delay who cr 
  loop
  ." ** t2 terminated **" cr
task.end

.( ** t2 scheduled **) cr
TASK-2 t2
who cr
t2 .task cr

16 16 task.type TASK-3
task.body
  1000 delay
  ." ** t3 signaling ** " cr
  synch signal
  ." ** t3 waiting for t2 **" cr
  t2 join who cr
  ." ** t3 terminated **" cr
task.end

.( ** t3 scheduled **) cr
TASK-3 t3
who cr 
t3 .task cr

.( ** main waiting for t3 **) cr
who cr
t3 join
who cr


forth only

