#!/bin/sh
mkdir -p dl/data
touch dl/data/databas.db

if test ! -d cvssource; then
  echo "specify full path to source code root dir"
  read code
  ln -sf $code cvssource
fi

cd libcurl/c
perl mkopts.pl
perl mkexam.pl

cd ../../dev
touch summary.t
touch cvs.t
touch keywords.txt
touch table.t
