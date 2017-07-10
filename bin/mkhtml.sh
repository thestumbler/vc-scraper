#!/bin/bash
# This script builds an html table file of tab delimited fields
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
  html-doc-header
  html-content-header 
  IFS=$'\t'
  while read SEQ DATE TYPE COMPANY AGE LOC FUND AMT TEXT; do
    html-content-entry
  done 
  html-content-trailer
  html-doc-trailer
}

function html-doc-header {
  echo "<html>"
  echo "<head>"
  echo "<title>Movies For Sale, List View</title>"
  echo "<meta http-equiv="Content-Type" content="text/html; charset=utf-8">"
  echo "</head>"
  echo "<body>"
}

function html-content-header {
  echo "<table border=1 rules=all cellpadding=2 text-indent=2 >"
  echo "<tr>"
  echo "  <th id="item">&nbsp;Item#&nbsp;</td>"
  echo "  <th id="date">&nbsp;Date&nbsp;</td>"
  echo "  <th id="type">&nbsp;Type&nbsp;</td>"
  echo "  <th id="company">&nbsp;Company&nbsp;</td>"
  echo "  <th id="age">&nbsp;Age&nbsp;</td>"
  echo "  <th id="loc">&nbsp;Location&nbsp;</td>"
  echo "  <th id="fund">&nbsp;Fund&nbsp;</td>"
  echo "  <th id="amt">&nbsp;Amount&nbsp;</td>"
  echo "  <th id="text">&nbsp;Text&nbsp;</td>"
  echo "</tr>"
}

# variables SEQ DATE TYPE COMPANY AGE LOC FUND AMT TEXT
function html-content-entry {
  echo "<tr>"
  echo "<td nowrap headers="item" align=left>&nbsp;$SEQ&nbsp;</td>"
  echo "<td nowrap headers="date" align=left>&nbsp;$DATE&nbsp;</td>"
  echo "<td nowrap headers="type" align=left>&nbsp;$TYPE&nbsp;</td>"
  echo "<td nowrap headers="company" align=left>&nbsp;$COMPANY&nbsp;</td>"
  echo "<td nowrap headers="age" align=left>&nbsp;$AGE&nbsp;</td>"
  echo "<td nowrap headers="loc" align=left>&nbsp;$LOC&nbsp;</td>"
  echo "<td nowrap headers="fund" align=left>&nbsp;$FUND&nbsp;</td>"
  echo "<td nowrap headers="amt" align=left>&nbsp;$AMT&nbsp;</td>"
  echo "<td headers="text" align=left>$TEXT</td>"
  echo "</tr>"
}

function html-content-trailer {
  echo "</table>"
  echo "<p>"
}
  
function html-doc-trailer {
  echo "</body>"
  echo "</html>"
}

main "$@"
