.( Loading Mappings test...) cr

#include mappings.f83
#include blocks.f83

blocks mappings

.( 1: Create symbols that always return pointers to their entry) cr

: item ( -- )
  create last ,
does> ( addr -- item)
  @
;
cr

.( 2: Define some common colors) cr

item white ( -- item)
item black ( -- item)
item yellow ( -- item)
item red ( -- item)
item green ( -- item)
item blue ( -- item)
item brown ( -- item)
item black ( -- item)
cr

.( 3: Create a color-value mapping; item x integer) cr

10 mapping COLOR-VALUE ( -- mapping)
COLOR-VALUE ?empty-mapping . COLOR-VALUE size-mapping . COLOR-VALUE .mapping cr
cr

.( 4: Add some mapping pairs; domain x range) cr

255 white COLOR-VALUE add-mapping
COLOR-VALUE ?empty-mapping . COLOR-VALUE size-mapping . COLOR-VALUE .mapping cr

0 black COLOR-VALUE add-mapping
COLOR-VALUE ?empty-mapping . COLOR-VALUE size-mapping . COLOR-VALUE .mapping cr
cr

.( 5: Check if range values are available) cr

red COLOR-VALUE ?range-mapping . 
white COLOR-VALUE ?range-mapping .
black COLOR-VALUE ?range-mapping . cr
cr

.( 6: Fetch range value and display) cr
red COLOR-VALUE range-mapping .
white COLOR-VALUE range-mapping @ .
black COLOR-VALUE range-mapping @ . cr 
cr

.( 7: Increment the black range value) cr

1 black COLOR-VALUE range-mapping +! 
COLOR-VALUE ?empty-mapping . COLOR-VALUE size-mapping . COLOR-VALUE .mapping cr
cr


.( 8: Add a red color mapping and remove successive pairs) cr

127 red COLOR-VALUE add-mapping
COLOR-VALUE ?empty-mapping . COLOR-VALUE size-mapping . COLOR-VALUE .mapping cr

red COLOR-VALUE remove-mapping
COLOR-VALUE ?empty-mapping . COLOR-VALUE size-mapping . COLOR-VALUE .mapping cr

white COLOR-VALUE remove-mapping
COLOR-VALUE ?empty-mapping . COLOR-VALUE size-mapping . COLOR-VALUE .mapping cr

black COLOR-VALUE remove-mapping
COLOR-VALUE ?empty-mapping . COLOR-VALUE size-mapping . COLOR-VALUE .mapping cr
cr

forth only
