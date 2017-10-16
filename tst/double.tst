.( Loading Double Parameter test...) cr

#include double.f83

1 2 3 4 .s cr
2swap .s cr
2over .s cr
2drop .s cr
2dup .s cr
2drop .s cr
5 6 .s cr
2rot .s cr

DOUBLE x ( -- double) .s cr

x .double cr
x 2@ .s cr
2drop .s cr
x 2! .s cr
x .double cr
2drop .s cr
x 2@ .s cr
2drop .s cr

10 42 double y ( -- low high)
y .s cr

forth only
