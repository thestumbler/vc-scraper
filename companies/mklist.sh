#!/bin/bash
# makes a markdown list of tab-separated fields, such as:
#
# SEQ  DATE        TYPE COMPANY            AGE          LOC              FUND      AMT   TEXT
# 1877 2017-Feb-09  nf  Greycroft Partners unk          unk              unk       unk   Greycroft Partners, with offices 
# 1878 2017-Feb-09  nf  Airbnb             unk          unk              unk       unk   Airbnb is in talks to buy Montre
# 1879 2017-Feb-10  ng  Botworx.ai         year-old     Los Altos, Ca.   seed fund $3    Botworx.ai, a year-old, Los Alt
# 1880 2017-Feb-10  ng  Capsule8           months-old   New York City    seed fund $2.5  Capsule8, a months-old, New Yo
# 1881 2017-Feb-10  ng  Demisto            1.5-year-old Cupertino, Ca.   unk       $20   Demisto, a 1.5-year-old, Cupe
# 1882 2017-Feb-10  ng  Empow              2.5-year-old Tel Aviv, Israel unk       $9    Empow, a 2.5-year-old, Tel A
# 1883 2017-Feb-10  ng  Evident.io         3.5-year-old unk              new fund  $22   Evident.io, a 3.5-year-old 
# 1884 2017-Feb-10  ng  HealthReveal       two-year-old New York         unk       $10.8 HealthReveal, a two-year-o
# 1885 2017-Feb-10  ng  Oncoinvent         six-year-old Oslo, Norway     unk       $25   Oncoinvent, a six-year-ol
# 1886 2017-Feb-10  nf  Nasdaq             unk          unk              unk       unk   Nasdaq is planning to se
#

function main {
  IFS=$'\t'
  while read SEQ DATE TYPE COMPANY AGE LOC FUND AMT TEXT; do
    markdown-entry
  done 
}

# variables SEQ DATE TYPE COMPANY AGE LOC FUND AMT TEXT
function markdown-entry {

  echo "= $COMPANY ="
  echo "ID: $SEQ"
  echo "Date: $DATE"
  echo "Type: $TYPE"
  echo "Company: $COMPANY"
  echo "Age: $AGE"
  echo "Location: $LOC"
  echo "Funding: $FUND"
  echo "Amount: $AMT"
  echo "Remarks: $TEXT"
  echo 
}

main "$@"
