#!/bin/sh

PATH="/userdir/dast/linux/bin:/usr/local/bin:/bin:/usr/bin:/usr/sbin:/sbin"

export PATH

# first remove oldies
find inbox -mtime +18 -exec rm {} \;

./summarize.pl 

cd curl
../last5commits.pl > ../dump 2>/dev/null
cd ..

if [ -s dump ]; then
  ./cvslast5.pl < dump > ./cvs.t 2>/dev/null
fi

make -k >/dev/null 2>&1

