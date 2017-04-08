#!/bin/bash
store="./mystore/"
for file in `find . -type f -name "index.html"`;
    do
        dir=$(dirname $file);
        bdir=$(basename $dir);
        bname=$(basename $file);
        new=$bdir-$bname;
        if [ "$file" != "$newname_with_path" ]
        then
            cp -a $file  $store$new ;
        fi
    done


    # replace 2 dots with nothing
    # bash 4.1.2 centos 6.4 no problem with or without bashslash
    newname=${new//../};
