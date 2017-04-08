#!/bin/bash
for file in `find . -type f -name "*.html"`;
    do
      YEAR=$(echo $file | cut -d'-' -f 1)
      MONTH=$(echo $file | cut -d'-' -f 2)
      DATE=$(echo $file | cut -d'-' -f 3)
      my_year=${YEAR:4:2}
      my_month=${MONTH:0:2}
      my_date=$DATE
      datetime=$my_year$my_month$my_date'0000'
      echo Touching: $datetime $file
      touch -t $datetime $file
    done

