#!/bin/bash
# renames files index.html to the name of the parent directory
if [ $# -lt 2 ]; then
  echo "usage:  fix-parents-names.sh  <path> <store>"
  echo 
  echo "where:         path      to search for index.html files"
  echo "               store     directory to store renamed files"
elif [ $# = 2 ]; then
  search=$1
  store=$2
  for file in `find $search -type f -name "index.html"`;
    do
      dir=$(dirname $file);
      bdir=$(basename $dir);
      bname=$(basename $file);
      new=$bdir-$bname;
      cp -a $file  $store$new ;
    done
fi

