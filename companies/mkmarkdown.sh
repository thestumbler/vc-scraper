#!/bin/bash
# This script builds an html table file of tab delimited fields
#
# SEQ  DATE        TYPE COMPANY            AGE          LOC              FUND      AMT   TEXT                              LINK
# 1877 2017-Feb-09  nf  Greycroft Partners unk          unk              unk       unk   Greycroft Partners, with offices  http://www.somelinkhere.com
# 1878 2017-Feb-09  nf  Airbnb             unk          unk              unk       unk   Airbnb is in talks to buy Montre  http://www.somelinkhere.com
# 1879 2017-Feb-10  ng  Botworx.ai         year-old     Los Altos, Ca.   seed fund $3    Botworx.ai, a year-old, Los Alt   http://www.somelinkhere.com
# 1880 2017-Feb-10  ng  Capsule8           months-old   New York City    seed fund $2.5  Capsule8, a months-old, New Yo    http://www.somelinkhere.com
# 1881 2017-Feb-10  ng  Demisto            1.5-year-old Cupertino, Ca.   unk       $20   Demisto, a 1.5-year-old, Cupe     http://www.somelinkhere.com
# 1882 2017-Feb-10  ng  Empow              2.5-year-old Tel Aviv, Israel unk       $9    Empow, a 2.5-year-old, Tel A      http://www.somelinkhere.com
# 1883 2017-Feb-10  ng  Evident.io         3.5-year-old unk              new fund  $22   Evident.io, a 3.5-year-old        http://www.somelinkhere.com
# 1884 2017-Feb-10  ng  HealthReveal       two-year-old New York         unk       $10.8 HealthReveal, a two-year-o        http://www.somelinkhere.com
# 1885 2017-Feb-10  ng  Oncoinvent         six-year-old Oslo, Norway     unk       $25   Oncoinvent, a six-year-ol         http://www.somelinkhere.com
# 1886 2017-Feb-10  nf  Nasdaq             unk          unk              unk       unk   Nasdaq is planning to se          http://www.somelinkhere.com
#

function main {
  mk-doc-header

  mk-summary-header 
  IFS=$'\t'
  while read SEQ DATE TYPE COMPANY AGE LOC FUND AMT TEXT LINK; do
    mk-summary-entry
  done < $1
  mk-summary-trailer

  mk-detail-header 
  IFS=$'\t'
  while read SEQ DATE TYPE COMPANY AGE LOC FUND AMT TEXT LINK; do
    mk-detail-entry
  done < $1
  mk-detail-trailer

  mk-doc-trailer
}

function mk-doc-header {
  echo "= List of Companies ="
}

function mk-summary-header {
  echo -n "| Item# "
  echo -n "| Date "
  echo -n "| Type "
  echo -n "| Company "
  echo -n "| Age "
  echo -n "| Location "
  echo -n "| Fund "
  echo -n "| Amount "
  echo    "|"

  echo -n "| ----- "
  echo -n "| ---- "
  echo -n "| ---- "
  echo -n "| ------- "
  echo -n "| --- "
  echo -n "| -------- "
  echo -n "| ---- "
  echo -n "| ------ "
  echo    "|"
}

# variables SEQ DATE TYPE COMPANY AGE LOC FUND AMT LINK TEXT
function mk-summary-entry {
  echo -n "| $SEQ "
  echo -n "| $DATE "
  echo -n "| $TYPE "
  echo -n "| $COMPANY "
  echo -n "| $AGE "
  echo -n "| $LOC "
  echo -n "| $FUND "
  echo -n "| $AMT "
  echo    "|"
}

function mk-summary-trailer {
  echo "End of Summary"
}
  

function mk-detail-header {
  echo
}

# variables SEQ DATE TYPE COMPANY AGE LOC FUND AMT LINK TEXT
function mk-detail-entry {
  echo "| Item#    | $SEQ      |"
  echo "| Date     | $DATE     |"
  echo "| Type     | $TYPE     |"
  echo "| Company  | $COMPANY  |"
  echo "| Age      | $AGE      |"
  echo "| Location | $LOC      |"
  echo "| Fund     | $FUND     |"
  echo "| Amount   | $AMT      |"
  echo "| Link     | $TEXT     |"
  echo "| Text     | $LINK     |"
  echo 
  echo 
}

function mk-detail-trailer {
  echo 
}
  

function mk-doc-trailer {
  echo "End of Document"
}

main "$@"
