#!/bin/sh

# meant to be updated by mkdash.pl
touch dash.gen

mkdir -p dl/data
mkdir -p download/archeology
touch dl/data/databas.db

if test ! -d cvssource; then
  echo "specify full path to curl source code root dir"
  read -r code
  ln -sf "${code}" cvssource
fi

if test ! -d trurl/trurl-www; then
  git clone https://github.com/curl/trurl.git trurl/trurl-www
fi

# Make manpage-option-menu.html from stdout.
perl generatemanmenu.pl "${code}" > _manpage-option-menu.html

touch ca/cacert.pem
touch ca/pemlist.gen

cd libcurl/c || exit 1
perl mkopts.pl
perl mkexam.pl

cd ../../dev || exit 1
touch summary.t
touch cvs.t
touch keywords.txt
touch table.t

