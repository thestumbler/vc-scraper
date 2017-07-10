#!/bin/bash

# Second phase of parsing data from Strictly VC newsletters
# Phase one is implemented in scrape.py, which scrapes the
# newsletter html files for the "New Funds" and "New Fundings"
# sections, and generates the following tab-separated output 
# file format:
#
# ITEM     DATE      NEW   FREE-FORM-TEXT-DESCRIPTION
#   1   2016-Jan-06   ng   Aver, a 5.5-year-old, Columbus, Oh.-based....
#   2   2016-Jan-06   ng   Entac Medical, a 4.5-year-old, Memphis,...
#   3   2016-Jan-06   ng   Flatiron Health, a three-year-old, New York...
#
# this script parses this output file, and attempts to extract 
# key information such as 
#   company name
#   comany age
#   company location
#   series funding
#   amount of funding
#
# Note: 
# This could probably be done in the python script.
# However, I started using bash functions to investigate how I might
# parse these fields, and by the time I figured out how to best sort
# them, I already had the ability in bash, so I kept it that way.


function main {
  if [ $# = 0 ]; then
    echo "usage:  parse filename [merge|name|age|base|series|bucks|itemno]"
    echo 
    echo "where:         filename  output of python scraping"
    echo "               [empty]   no 2nd arg, parses all fields"
    echo "               name      parses only the company names"
    echo "               age       parses only the company ages"
    echo "               base      parses only the company base locations"
    echo "               series    parses only the funding series"
    echo "               bucks     parses only the funding amounts"
    echo "               merge     performs final merge of parsed files"
    echo "               itemno    makes lineno/itemno file, for debugging"
  elif [ $# = 1 ]; then
    total=$(cat $1 | wc -l)
    echo "total company reports: " $total
    parse_names $1 parsed-names-raw
    parse_ages $1 parsed-ages
    parse_based $1 parsed-based
    parse_series $1 parsed-series
    parse_bucks $1 parsed-bucks
  elif [ "$2" = "name" ]; then
    parse_names $1 parsed-names-raw
  elif [ "$2" = "age" ]; then
    parse_ages $1 parsed-ages
  elif [ "$2" = "base" ]; then
    parse_based $1 parsed-based
  elif [ "$2" = "series" ]; then
    parse_series $1 parsed-series
  elif [ "$2" = "bucks" ]; then
    parse_bucks $1 parsed-bucks
  elif [ "$2" = "merge" ]; then
    parse_merge_all $1
  elif [ "$2" = "itemno" ]; then
    parse_make_itemno $1
  else
    echo "Unknown parameters"
  fi
}

# join command can only do two files at once
# let's make an output file with these columns:
#
#      item#  date  new   name  age   base  series  bucks   full-text-writeup
# main   1      2    3                                            4
# parsed-names             2
# parsed-ages                    2
# parsed-based                         2
# parsed-series                               2
# parsed-bucks                                        2
#
function parse_merge_all {

  cat $1    \
  | join -a 1 -e'unk' -t$'\t' -o '1.1,1.2,1.3,2.2'                     - parsed-names \
  | join -a 1 -e'unk' -t$'\t' -o '1.1,1.2,1.3,1.4,2.2'                 - parsed-ages  \
  | join -a 1 -e'unk' -t$'\t' -o '1.1,1.2,1.3,1.4,1.5,2.2'             - parsed-based \
  | join -a 1 -e'unk' -t$'\t' -o '1.1,1.2,1.3,1.4,1.5,1.6,2.2'         - parsed-series \
  | join -a 1 -e'unk' -t$'\t' -o '1.1,1.2,1.3,1.4,1.5,1.6,1.7,2.2'     - parsed-bucks  \
  | join -a 1 -e'unk' -t$'\t' -o '1.1,1.2,1.3,1.4,1.5,1.6,1.7,1.8,2.4' - $1\
  > merged

  
}

function parse_merge_all_test {
  cut -f1 $1  \
    > item
  cat item | LOCALE=C join -a 1 -e 'unk' -t$'\t' -o '1.1,2.2'  - parsed-ages   > merged-ages
  cat item | LOCALE=C join -a 1 -e 'unk' -t$'\t' -o '1.1,2.2'  - parsed-based  > merged-based
  cat item | LOCALE=C join -a 1 -e 'unk' -t$'\t' -o '1.1,2.2'  - parsed-series > merged-series
  cat item | LOCALE=C join -a 1 -e 'unk' -t$'\t' -o '1.1,2.2'  - parsed-bucks  > merged-bucks
}

# in all the parse-xxxx functions below, the item number (column 1) is
# dropped, then re-inserted using a join command such as:
#   cat -n out.dat | cut -f1-2 | sed 's/^ *//' > itemno
#

# ========================================================================
# company name
# usually the company name is at the beginning of the sentence
# terminated by a comma
# This file has to be manually edited before final merging
# there are too many exceptions
function parse_names {
  cat -n out.dat | cut -f1-2 | sed 's/^ *//' > itemno
  cut -f4 $1 \
    | grep -n -o -E "^[^,]*," \
    | sed $'s/,$//' \
    | sed $'s/:/\t/' \
    | grep '^[0-9]' \
    | grep -v '^[0-9][0-9][0-9] ' \
    | grep -v '^[0-9][0-9][0-9]$' \
    | join -t$'\t' -o '2.2,1.2' - itemno \
    > $2
    rm itemno
  echo "company names parsed: $2 $(cat $2 | wc -l) lines"
}

# ========================================================================
# make line number vs. item number table
function parse_make_itemno {
  cat -n out.dat | cut -f1-2 | sed 's/^ *//' > itemno
  echo "made item number file, $(cat itemno | wc -l) lines"
}

# ========================================================================
# how long has the company been around
# look for these common key words
function parse_ages {
  cat -n out.dat | cut -f1-2 | sed 's/^ *//' > itemno
  age=0
  age=$(($age+$(grep 'year\-old' $1 | wc -l)))
  age=$(($age+$(grep 'years\-old' $1 | wc -l)))
  age=$(($age+$(grep 'month\-old' $1 | wc -l)))
  age=$(($age+$(grep 'months\-old' $1 | wc -l)))
  age=$(($age+$(grep 'week\-old' $1 | wc -l)))
  age=$(($age+$(grep 'weeks\-old' $1 | wc -l)))
  age=$(($age+$(grep ', a new' $1 | wc -l)))
  echo "company age tag: " $age

  age_match=', a (.*?)year\-old'
  age_match+='|, a (.*?)years\-old'
  age_match+='|, a (.*?)month\-old'
  age_match+='|, a (.*?)months\-old'
  age_match+='|, a (.*?)week\-old'
  age_match+='|, a (.*?)weeks\-old'
  age_match+='|, a new'

  grep -n -o -E "$age_match" $1 \
    | sed $'s/:, a /\t/' \
    | sed $'s/-old$$//' \
    | grep '^[0-9]' \
    | sed '/^.\{100,\}$/d' \
    | join -t$'\t' -o '2.2,1.2' - itemno \
    > $2
 
  rm itemno

  echo "company ages parsed: $2 $(cat $2 | wc -l) lines"
#    | sed 's/^([0-9])  /000$1  /' |
}


# ========================================================================
# where is the company based
# look for "-based"
function parse_based {
  cat -n out.dat | cut -f1-2 | sed 's/^ *//' > itemno

  base=0
  base=$(($base+$(grep '\-based' $1 | wc -l)))
  echo "company base tag: " $base

  # this is the main grep command
  # use line numbers to get the first match on the line
  # throw away all subsequent matches

  # This first command is only used for checking
  # cat $1 \
  #   | grep -n -E -o 'old, (.*?)\-based' \
  #   | grep '^[0-9]' \
  #   | cut -d':' -f2 \
  #   > cut3

  # grabs the words before "based"
  cat $1 \
    | grep -n -E -o 'old, (.*?)\-based' \
    | grep '^[0-9]' \
    | cut -d':' -f2 \
    | sed "s/^old, //" \
    | sed "s/-based$//" \
    > cut2

  # grab just the line number
  cat $1 \
    | grep -n -E -o 'old, (.*?)\-based' \
    | grep '^[0-9]' \
    | cut -d':' -f1 \
    > cut1
  
  paste  cut1 cut2 \
    | join -t$'\t' -o '2.2,1.2' - itemno \
    > $2
  rm itemno
  echo "company locations parsed: $2 $(cat $2 | wc -l) lines"
}


# ========================================================================
# Which series funding
# look for "series...fund"
# look for "seed...fund"
# look for "new...fund"
function parse_series {
  cat -n out.dat \
    | cut -f1-2 \
    | sed 's/^ *//' \
    | sed $'s/^\([1-9]\)\t/000\\1\t/'  \
    | sed $'s/^\([1-9][0-9]\)\t/00\\1\t/'  \
    | sed $'s/^\([1-9][0-9][0-9]\)\t/0\\1\t/'  \
    > itemno
 
  series_match='series .*fund'
  seed_match='seed .*fund'
  new_match+='new .*fund'

  # This count is a crude number, actual count will be lower
  # because of repeats of the search terms, which are removed 
  # in the actual processing below
  series=0
  series=$(($series+$(grep -i -E "$series_match" $1 | wc -l)))
  series=$(($series+$(grep -i -E "$seed_match" $1 | wc -l)))
  series=$(($series+$(grep -i -E "$new_match" $1 | wc -l)))
  echo "series funding tag: " $series

  grep -n -o -i -E "$series_match" $1 \
    | sed $'s/:/ /' \
    | grep '^[0-9]' \
    | cut -d' ' -f1-3 \
    | sed $'s/ /\t/' \
    | sed $'s/^\([1-9]\)\t/000\\1\t/'  \
    | sed $'s/^\([1-9][0-9]\)\t/00\\1\t/'  \
    | sed $'s/^\([1-9][0-9][0-9]\)\t/0\\1\t/'  \
    > ser1

  grep -n -o -i -E "$seed_match" $1 \
    | grep -v -i "series" \
    | sed $'s/:/\t/' \
    | grep '^[0-9]' \
    | sed '/^.\{30,\}$/d' \
    | sed $'s/^\([1-9]\)\t/000\\1\t/'  \
    | sed $'s/^\([1-9][0-9]\)\t/00\\1\t/'  \
    | sed $'s/^\([1-9][0-9][0-9]\)\t/0\\1\t/'  \
    > ser2

  grep -n -o -i -E "$new_match" $1 \
    | grep -v -i "series" \
    | sed $'s/:/\t/' \
    | grep '^[0-9]' \
    | sed '/^.\{30,\}$/d' \
    | sed $'s/^\([1-9]\)\t/000\\1\t/'  \
    | sed $'s/^\([1-9][0-9]\)\t/00\\1\t/'  \
    | sed $'s/^\([1-9][0-9][0-9]\)\t/0\\1\t/'  \
    > ser3
 
  # this method merges any duplicates
  cat ser1 ser2 ser3 \
    | sort -n  \
    | tee temp1 \
    | join -t$'\t' -o '2.2,1.2' - itemno \
    > $2

  rm ser1 ser2 ser3 itemno
  echo "series fundings parsed: $2 $(cat $2 | wc -l) lines"
}

# ========================================================================
# amount raised
# look for "million"
#
function parse_bucks {
  cat -n out.dat | cut -f1-2 | sed 's/^ *//' > itemno
  bucks=$(($bucks+$(grep 'million' $1 | wc -l)))
  echo "amount raised tag: " $bucks

  # grabbing words before the match
  # we have to deal with adjectives like:
  #
  # raised a XXX million
  # raised a fresh XXX million
  # raised a new XXX million
  # raised a new, XXX million
  # raised a new round of XXX million
  # raised a whopping XXX million
  # raised an additional XXX million
  # raised about XXX million
  # raised another XXX million
  # raised around XXX million
  # raised at least XXX million
  # raised between XXX million
  # raised just XXX million
  # raised just over XXX million
  # raised more than XXX million
  # raised nearly XXX million
  # raised over XXX million
  # raised raised XXX million
  # raised roughly XXX million
  #
  # raised .... totalling XXX million
  # raised "significantly more" than XXX million
  #
  # raised an undisclosed amount
  #

  # this is the main grep command
  # use line numbers to get the first match on the line
  # throw away all subsequent matches

  # This first command is only used for checking
  # cat $1 \
  #   | grep -n -E -o 'raised (.*?)million' \
  #   | grep '^[0-9]' \
  #   | cut -d':' -f2 \
  #   > cut3

  # grabs the number before "million"
  cat $1 \
    | grep -n -E -o 'raised (.*?)million' \
    | grep '^[0-9]' \
    | cut -d':' -f2 \
    | rev | cut -d' ' -f2 | rev > cut2
  # grab just the line number
  cat $1 \
    | grep -n -E -o 'raised (.*?)million' \
    | grep '^[0-9]' \
    | cut -d':' -f1 \
    > cut1
  paste  cut1 cut2 \
    | join -t$'\t' -o '2.2,1.2' - itemno \
    > $2

  rm cut1 cut2 itemno
  echo "funding amounts parsed: $2 $(cat $2 | wc -l) lines"
}

main "$@"

