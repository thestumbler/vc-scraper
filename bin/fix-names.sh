#!/bin/bash

# rename "s/january/jan/" *.html
# rename "s/february/feb/" *.html
# rename "s/march/mar/" *.html
# rename "s/april/apr/" *.html
# rename "s/may/may/" *.html
# rename "s/june/jun/" *.html
# rename "s/july/jul/" *.html
# rename "s/august/aug/" *.html
# rename "s/september/sep/" *.html
# rename "s/october/oct/" *.html
# rename "s/november/nov/" *.html
# rename "s/december/dec/" *.html

# rename "s/\-1\-/-01-/" *.html
# rename "s/\-2\-/-02-/" *.html
# rename "s/\-3\-/-03-/" *.html
# rename "s/\-4\-/-04-/" *.html
# rename "s/\-5\-/-05-/" *.html
# rename "s/\-6\-/-06-/" *.html
# rename "s/\-7\-/-07-/" *.html
# rename "s/\-8\-/-08-/" *.html
# rename "s/\-9\-/-09-/" *.html

# rename "s/jan/01jan/" *.html
# rename "s/feb/02feb/" *.html
# rename "s/mar/03mar/" *.html
# rename "s/apr/04apr/" *.html
# rename "s/may/05may/" *.html
# rename "s/jun/06jun/" *.html
# rename "s/jul/07jul/" *.html
# rename "s/aug/08aug/" *.html
# rename "s/sep/09sep/" *.html
# rename "s/oct/10oct/" *.html
# rename "s/nov/11nov/" *.html
# rename "s/dec/12dec/" *.html

# rename -v  's/^(.....)\-(..)\-(....)/$3-$1-$2/'  *.html

rename "s/01jan/01/" *.html
rename "s/02feb/02/" *.html
rename "s/03mar/03/" *.html
rename "s/04apr/04/" *.html
rename "s/05may/05/" *.html
rename "s/06jun/06/" *.html
rename "s/07jul/07/" *.html
rename "s/08aug/08/" *.html
rename "s/09sep/09/" *.html
rename "s/10oct/10/" *.html
rename "s/11nov/11/" *.html
rename "s/12dec/12/" *.html
