#!/bin/bash
#
# partial attempt to merge morehere links into company file
# gave up

function main {
  awk -v FS="\n" -v RS="" -v OFS='\t' \
    '{ print NR, NF;\
      for(i=1; i<=NF; i++) { \
        if("ID: " == substr($i,1,4)) print NR, $1; \
      } \
    }' $1 
}

#    '{ print $1, $2, $3, $4, $5, $6, $7, $8 }' \
#    '{ print NR, NF }' \
main "$@"


# Instead...
#
# did it in vim semi-manually
#
# made script file mygrep.sh

#################
# #!/bin/bash
# 
# function main {
#   VALUE="${@}"
#   grep -i "$VALUE" morehere.txt |
#   cut -f3 |
#   sed "s/^/Morehere: /"
# }
# 
# main "$@"
#################

# in vim, put this command-mode partial command in the "a register:
# (excluding the newline, e.g., "ay$, not "ayy)
#       r!mygrep.sh 
# then mapped this macro: 
#       map v /^Remarks:^[:^Ra^R"^M    
# usage:
# 1. go to the top of an entry,
# 2. yank the company name into the immediate register, e.g., 
#       yw  or y2w  or  y3w, etc.
# 3. execute the macro:
#       v
# This will move the cursor to the Remarks: line, 
# and builds the command:
#       r!mygrep.sh <Company-Name>
# which inserts a new "Morehere: " line immediately below.
#
