#!/bin/sh

DUMP="latest.curl2"

perl ./latest.pl > $DUMP 2>/dev/null

if [ -s "$DUMP" ] ; then
 mv latest.curl2 latest.curl
fi
