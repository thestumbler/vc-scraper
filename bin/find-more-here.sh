#!/bin/bash
# find the more-here links
#
#
# Note: these "more here" expressions have to be found and added to the regex alteration group 
#   More here
#   longer look
#   here
#   scoop here
#
# This function is invoked as follows:
# $ find-more-here.sh grep-names.txt > morehere.txt
#
# The output morehere.txt must be manually edited, 
# remove duplicates (delete the ======== separator lines, too)
# delete the 2nd and 3rd columms
# Then the file can be merged back into the companies list,
# keying on the JD2000 date sequence number / company name
#
#
# the directory glob for the html files is hard coded
#
# Test case 
# 11-Feb-2017
# JD = 2457429.5 
# JD2000 = 5884

function main {
  DATAFILES="../data/*.html"
  # getlinks < $1 |
  # mkjulian > out.txt
  cat grep-names.txt | match_em out.txt
}

# Finds the matches:
# There may be multiple mentions of a company over all of the newsletters 
#   $1 ( temporary file out.txt )
# But we just want the mentions of interest on the dates specified 
#   stdin ( from grep-names.txt )
#
# This isn't perfect ******
# resulting output file must be manually edited
# some companies will me mentioned multiple times in a newsletter
# must manually delete the unwanted entries
function match_em {
  IFS=$'\t'
  while read MYDATE6 MYCOMPANY; do
    MYDATE=$( echo $MYDATE6 | sed "s/..$//" )
    echo ========= $MYDATE6 $MYDATE $MYCOMPANY =========
    while read DATE1 DATE2 COMPANY URL; do
      if (( MYDATE >= DATE1 && MYDATE <= DATE2 )) && [ $MYCOMPANY == $COMPANY ]; then
        echo $MYDATE$'\t'$DATE1$'\t'$DATE2$'\t'$COMPANY$'\t'$URL
      fi
    done < $1
  done
}


# loops over the company names in the input file (grep-names.txt in this project)
# finds all corresponding matches in the html files
# saves the results in $2 file (morehere.txt)
function getlinks {
  IFS=$'\t'
  while read SEQ COMPANY; do
    # echo ========= $SEQ $COMPANY  ===========
    grep $COMPANY $DATAFILES \
    | sed -E -n "s/^([^:]*):.*($COMPANY).*<a href=\"([^\"]*)\">([Mm]ore [Hh]ere|longer look|here|scoop here).*$/\1	\2	\3/p"
  done
}

# input is morehere.txt file
# convert the date strings to our julian data index number
# parameter is the morehere.txt file
function mkjulian {
  IFS=$'\t'
  while read FILENAME COMPANY URL; do
    NEWDATE=$( echo "$FILENAME" | sed -E -n \
    -e $'s/^.*(201[0-9]-[01][0-9]-[0123][0-9])-thru-(201[0-9]-[01][0-9]-[0123][0-9]).*$/\\1\t\\2/p' \
    -e $'s/^.*(201[0-9]-[01][0-9]-[0123][0-9])-index.*$/\\1\t\\1/p' )
    NEWJUL=$( IFS=$'\t'; echo "$NEWDATE" | \
    while read DATE1 DATE2; do
      if [ -n "$DATE1" ]; then echo -n      $( date_to_jul $DATE1 ); fi
      if [ -n "$DATE2" ]; then echo -n $'\t'$( date_to_jul $DATE2 ); fi
      echo
    done )
    # echo "$NEWDATE"$'\t'"$NEWJUL"$'\t'$COMPANY$'\t'$URL
    echo "$NEWJUL"$'\t'$COMPANY$'\t'$URL
  done

#  cut -f1 $1 | sed -E -n \
#    -e "s/^.*(201[0-9]-[01][0-9]-[0123][0-9])-thru-(201[0-9]-[01][0-9]-[0123][0-9]).*$/\1 \2/p" \
#    -e "s/^.*(201[0-9]-[01][0-9]-[0123][0-9])-index.*$/\1/p" |\
#  while read DATE1 DATE2; do
#    if [ -n "$DATE1" ]; then echo -n      "$( date_to_jul $DATE1 )"; fi
#    if [ -n "$DATE2" ]; then echo -n "$'\t'$( date_to_jul $DATE2 )"; fi
#    echo
#  done

}

function date_to_jul {
  J0001=1721424 
  J1970=2440587
  J2000=2451545
  J2010=2455197
  J2016=2457388 
  echo $(( $(date -j -f "%Y-%m-%d" $1 +%s) / 86400 + J1970 - J2000 + 1  ))
}

main "$@"
