#!/bin/bash

function main {
  VALUE="${@}"
  grep -i "$VALUE" morehere.txt |
  cut -f3 |
  sed "s/^/Morehere: /"
}

main "$@"
