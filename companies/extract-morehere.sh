#!/bin/bash
#
# rebuild one-line database including the more-here links
# yeah, we already split the one-line database into multi-line
# and now putting it back together again.
#    probably could do it before the split up, 
#    but I decided to extract the more-here links 
#    after I had already split it up. 
#
# Weirdness TBD
# awk freaks on the strings ID and Morehere
#   I see where ID is a built-in variable
#   I have no idea why Morehere is a problem
# Therefore changed the key tag in the data file companies.txt:
#   changed ID ==> SEQ
#   changed Morehere ==> Linkhere


function main {
  awk -v FS="\n" -v RS="" -v OFS='' -v ORS='' \
    'BEGIN { \
      array[1]="SEQ: "; \
      array[2]="Date: "; \
      array[3]="Type: "; \
      array[4]="Company: "; \
      array[5]="Age: "; \
      array[6]="Location: "; \
      array[7]="Funding: "; \
      array[8]="Amount: "; \
      array[9]="Remarks: "; \
      array[10]="Linkhere: "; \
      alen = 0; \
      for(i in array) alen++; \
#      print "\n"; \
#      print alen, "\n"; \
#      for (i=1; i<=10; i++) { print i, array[i], length(array[i])"\n" }; \
    } \
    { \
      for(i=1; i<=NF; i++) { \
        for(j=1; j<=alen; j++) { \
          if(array[j] == substr($i,1,length(array[j]))) print substr($i,length(array[j])+1), "\t"; \
        } \
      } \
      print "\n" \
    }' $1

}

#    '{ print $1, $2, $3, $4, $5, $6, $7, $8 }' \
#    '{ print NR, NF }' \

#      for (i in array) { print i, array[i], "\n" }; \
main "$@"

