#!/bin/bash
# join multiple txt files into based on column
# run it as:
# joinr.sh *.txt > combined_file.out
# Files should be sorted prior to joining
# first field is used as the key for joining (but can be modified by editing the script)
# arnstrm@gmail.com
# source: http://stackoverflow.com/a/18153506/1564521

if [[ $# -ge 2 ]]; then
    function __r {
        if [[ $# -gt 1 ]]; then
            exec join - "$1" | __r "${@:2}"
        else
            exec join - "$1"
        fi
    }

    __r "${@:2}" < "$1"
fi
