#!/bin/bash

if [ $# = 0 ]; then
  echo "usage:  parse filename [merge|name|age|base|series|bucks]"
  echo 
  echo "where:         filename  output of python scraping"
  echo "               [empty]   no 2nd arg, parses all fields"
  echo "               name      parses only the company names"
  echo "               age       parses only the company ages"
  echo "               base      parses only the company base locations"
  echo "               series    parses only the funding series"
  echo "               bucks     parses only the funding amounts"
  echo "               merge     performs final merge of parsed files"
elif [ $# = 1 ]; then

files=("$@")

for file in ${files[@]}
    do
      echo $file
    done


