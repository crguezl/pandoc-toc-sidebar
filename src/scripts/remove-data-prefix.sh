#!/usr/bin/env bash
USAGE="Usage: $0 temp.html index.html"
DESCRIPTION='   Removes "data-v-*" prefixes from input file'

if [ "$#" -lt "2" ]; then
	echo "$USAGE"
    echo $DESCRIPTION
	exit 1
fi

SOURCE=$1
TARGET=$2
sed -E -ne 's/data-v-([a-z]+)/v-\1/;p' $SOURCE > $TARGET; 
rm $SOURCE