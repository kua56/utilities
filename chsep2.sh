#!/bin/bash

# change separator
# $1 file to process
# $2 original separator
# $3 change separator

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
[ "${#org}" -eq 1 ] || ERROR "${org} must be 1 character long" 2>&1
[ "${#chg}" -eq 1 ] || ERROR "${chg} must be 1 character long" 2>&1

cat "${file}" |
tr "${org}" "${chg}"
