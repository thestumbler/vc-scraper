#!/bin/bash
# This script filters the merged scraped file for the companies of
# interest.  In this case, IOT and AI companies
#
# 1    2           3    4                  5            6                7         8     9 
# SEQ  DATE        TYPE COMPANY            AGE          LOC              FUND      AMT   TEXT
# 1877 2017-Feb-09  nf  Greycroft Partners unk          unk              unk       unk   Greycroft Partners, with offices 
# 1878 2017-Feb-09  nf  Airbnb             unk          unk              unk       unk   Airbnb is in talks to buy Montre
# 1879 2017-Feb-10  ng  Botworx.ai         year-old     Los Altos, Ca.   seed fund $3    Botworx.ai, a year-old, Los Alt
# 1880 2017-Feb-10  ng  Capsule8           months-old   New York City    seed fund $2.5  Capsule8, a months-old, New Yo

# This main function could be further simplified, 
# if multiple search terms were desired, besides just the two here
# in that case, you'd pass the search term, terms to cleanup, and the filename
function main {

# IOT Internet of Things
  cat $1 \
  | search_term "iot" \
  | search_clean "biot" \
  | search_clean "liot" \
  | search_clean "riot" \
  > temp-iot.txt

  cat $1 \
  | search_term "internet of things" \
  >> temp-iot.txt

  cat temp-iot.txt | remove_duplicates > grep-iot.txt
  rm temp-iot.txt
  wc -l grep-iot.txt
  cut -d$'\t' -f1,4 grep-iot.txt > grep-iot-names.txt



# AI Artificial Intellegence 
  cat $1 \
  | search_term " ai " \
  > temp-ai.txt
 
  cat $1 \
  | search_term "artificial intelligence" \
  >> temp-ai.txt
 
  cat temp-ai.txt | remove_duplicates > grep-ai.txt
  rm temp-ai.txt
  wc -l grep-ai.txt
  cut -d$'\t' -f1,4 grep-ai.txt > grep-ai-names.txt


}



# $1 search term
# $2 optional grep options
function search_term {
    grep -n $2 -i "$1" \
  | grep "[0-9]:"        `# only grab first occurence per line` \
  | sed $'s/:/\t/'       `# make the line number into a tab-delimited field...`\
  | cut -d$'\t' -f2-     `# and remove the line number` \

}

# $1 clean search term
function search_clean {
  grep -v -i "$1" 

}

function remove_duplicates {
  sort | uniq

}

main "$@"
