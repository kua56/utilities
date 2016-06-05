#!/bin/bash

# 1: file
# 2: org position
# 3: dest position

file=${1}
org=${2:-1}
dest=${3:-1}

USAGE() {
    echo "usage: switchcol.sh <file> <org> <dest>"
    exit 1
}

[ "$#" -eq 0 ] && USAGE >&2

ERROR() {
    echo "$1" >&2
    exit 1
}

[ -f ${file} ] || ERROR "$1 is not found"
[ "$(wc -l ${file} | cut -d" " -f1)" -eq 0 ] && ERROR "$1 is empty"

cat ${file} |
awk -F: -v org=${org} -v dest=${dest} '
{
    line = ""
    sep1 = ""
    for (i = 1; i <= NF; i++) {
        if (i == org) {
            line = line sep1 $(dest)
        } else if (i == dest) {
            line = line sep1 $(org)
        } else {
            line = line sep1 $(i)
        }

        if (i == 1) {
            sep1 = ":"
        }
    }
    print line
    #print $(NF - 3), $(NF - 2)
}
'
