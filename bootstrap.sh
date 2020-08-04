#!/bin/sh

# meant to be updated by mkdash.pl
touch dash.gen

mkdir -p dl/data
touch dl/data/databas.db

if test ! -d cvssource; then
  echo "specify full path to source code root dir"
  read code
  ln -sf $code cvssource
fi

touch ca/cacert.pem
touch ca/pemlist.gen

# This links to a *built* curl.1 file
ln -rsf cvssource/docs/curl.1 docs/curl.1

cd libcurl/c
perl mkopts.pl
perl mkexam.pl

cd ../../dev
touch summary.t
touch cvs.t
touch keywords.txt
touch table.t
