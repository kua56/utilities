#!/bin/bash
######################################################
# function:
# convert a variable length file to a fixed length file
#
# params:
# $1 orgfile
# $2 formatfile
# $3 separator
# $4 filler
#
# formatfile format
# length, [l|r]
# l for left padding, r for right padding
######################################################

function USAGE() {
cat << EOL
Usage:
    padding.sh orgfile formatfile separator filler
    orgfile - file for padding
    formatfile - file to specifiy format(length, [l|r])
    separator - separater
    filler - filler

Option:
    no option for now
 
EOL
exit -1
}

[ $# -eq 4 ] || USAGE

function ERROR() {
    echo "$1" >&2
    exit -1
}

file="${1}"
format="${2}"
sep="${3}"
filler="${4}"

[ -f "${file}" ] || ERROR "${file} not found" 2>&1
[ -f "${format}" ] || ERROR "${format} not found" 2>&1
[ "x${sep}" == "x" ] && ERROR "separator is empty" 2>&1
[ "x${filler}" == "x" ] && ERROR "filler is empty" 2>&1

cat "${file}" |
awk -F"${sep}" -v separator="${sep}" -v format="${format}" -v filler="${filler}" '

# read format file
BEGIN {
    i = 1
    while((getline line < format) > 0) {
        formats[i] = line
        i++
    }
}

# set format
NR == 1 {
    for (i = 1; i <= NF; i++) {
        split(formats[i], sep, ",")

        if (sep[2] == "l") {
            lfiller[i] = filler
            rfiller[i] = ""
        } else {
            lfiller[i] = ""
            rfiller[i] = filler
        }
    }
}

# padding
{
    line = ""
    for (i = 1; i <= NF; i++) {
        elm = $(i)
        while (length(elm) < sep[1]) {
            elm = lfiller[i] elm rfiller[i]
        }

        line = line elm separator
    }

    # take out last separator
    len = length(line) - length(separator)
    line = substr(line, 1, len)
    print line
}
'
