#!/bin/bash

# change separator
# $1 original separator
# $2 change separator

function USAGE() {
cat << EOL
Usage:
    chsep.sh file org chg
    switch separeter from org to chg.

Option:
    no option for now.

EOL
exit -1
}

[ "$#" -eq 3 ] || USAGE

file="$1"
org="$2"
chg="$3"

function ERROR() {
    echo "$1" >&2
    exit -1
}

[ -f "${file}" ] || ERROR "${file} is not found" 2>&1

cat "${file}" |
awk -F"${org}" -v chg="${chg}" '
{
    line = ""
    for (i = 1; i < NF; i++) {
        line = line $(i) chg
    }
    print line $(NF)
}
'
