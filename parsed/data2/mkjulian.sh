#!/bin/bash

# This is a one-time usage script
# It makes a lookup table of item numbers (first column) 
# to a new item number which is simply the J2000-based 
# Julian date of the date in the second column
#
# This is needed to map records from before I changed the item
# number from a simple sequential counter to the J2000 date.
# After creating this map file:
#   $ mkjulian.sh < merged-all.txt > map 
# Make the new parsed-names file as follows:
#   $ join -t$'\t' -o '2.2,1.2' parsed-names map > parsed-names2

function main {
  last_date=""
  count=0
  IFS=$'\t'
  while read ITEM DATE TYPE STRING; do
    if [ "$DATE" != "$last_date" ]; then 
      count=0 
    fi
    count=$((count+1))
    # echo $ITEM, $DATE, $( date_to_jul $DATE ), $( printf "%02d" $count), ${STRING:0:20}
    echo $ITEM$'\t'$( date_to_jul $DATE )$( printf "%02d" $count )
    last_date=$DATE
  done 

}

# ========================================================================
# make line number vs. item number table
function date_to_jul {
  J0001=1721424 
  J1970=2440587
  J2000=2451545
  J2010=2455197
  J2016=2457388 
  echo $(( $(date -j -f "%Y-%b-%d" $1 +%s) / 86400 + J1970 - J2000  ))
}

main "$@"


