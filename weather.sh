#!/bin/sh
#wunderground RSS weather tool for conky
#
#USAGE: weather.sh <locationcode>
#
#addapted from Michael Seiler's weather script for Accuweather 2007
# Erich L Foster 2013

METRIC=1 #Should be 0 or 1; 0 for F, 1 for C

if [ ${METRIC} ]; then
    METRIC='metric'
else
    METRIC='english'
fi

if [ -z $1 ]; then
    echo
    echo "USAGE: weather.sh <locationcode>"
    echo
    exit 0;
fi

curl -s http://rss.wunderground.com/auto/rss_full/global/stations/$1.xml\?units=${METRIC} | perl -ne 'if (/Current/) {chomp;/<title>Current Conditions\s*:\s*(-?\d+\.?\d?[CF]), (.+) - \d.+<\/title>/; print "$1 $2"; }'
