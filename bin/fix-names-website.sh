#!/bin/bash

# names from the site come in the forms:
# When you save the newsletter from an email:
#   StrictlyVC - April 5, 2017.html

# When you fetch from the website:
#   strictlyvc-april-5-2017/index.html
# first, convert the index.html filenames to
# have the name of the parent directory, see
# script file fix-name-parents.sh
# 

# == strip off the "strictlyvc-" portion of the filename
rename "s/^strictlyvc-//" *.html

# == Change month names to numbers ==
rename   "s/january/01/" *.html
rename  "s/february/02/" *.html
rename     "s/march/03/" *.html
rename     "s/april/04/" *.html
rename       "s/may/05/" *.html
rename      "s/june/06/" *.html
rename      "s/july/07/" *.html
rename    "s/august/08/" *.html
rename "s/september/09/" *.html
rename   "s/october/10/" *.html
rename  "s/november/11/" *.html
rename  "s/december/12/" *.html

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
rename -v  's/^(..)\-(..)\-(....)/$3-$1-$2/'  *.html

