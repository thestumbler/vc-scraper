#!/bin/bash

# names from the site come in the forms:
# When you save the newsletter from an email:
#   StrictlyVC - April 5, 2017.html

# == strip off the "StrictlyVC - " portion of the filename
#    and replace the white space / comma with dashes
rename "s/^StrictlyVC - //" *.html
rename "s/ /-/" *.html
rename "s/, /-/" *.html

# == Change month names to numbers ==
rename   "s/January/01/" *.html
rename  "s/February/02/" *.html
rename     "s/March/03/" *.html
rename     "s/April/04/" *.html
rename       "s/May/05/" *.html
rename      "s/June/06/" *.html
rename      "s/July/07/" *.html
rename    "s/August/08/" *.html
rename "s/September/09/" *.html
rename   "s/October/10/" *.html
rename  "s/November/11/" *.html
rename  "s/December/12/" *.html

# == Add a leading zero to single-digit dates ==
rename "s/\-1\-/-01-/" *.html
rename "s/\-2\-/-02-/" *.html
rename "s/\-3\-/-03-/" *.html
rename "s/\-4\-/-04-/" *.html
rename "s/\-5\-/-05-/" *.html
rename "s/\-6\-/-06-/" *.html
rename "s/\-7\-/-07-/" *.html
rename "s/\-8\-/-08-/" *.html
rename "s/\-9\-/-09-/" *.html

# == reorder the date to be year-month-date
rename -v  's/^(..)\-(..)\-(....)/$3-$1-$2-index/'  *.html

