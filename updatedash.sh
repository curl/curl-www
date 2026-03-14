#!/bin/sh

#
# Requires:
#
# 'dash' - a separate stand-alone curl git repo clone
# 'dast/stats' - a curl/stats repo clone
#
# Creates SVG files in 'dash/svg-NNNNNN' and
# 'dash.gen' - HTML for the SVG files

dir="dash";

orgdir=`pwd`;

cd $dir

# store the SVG and CSV files here
svg=`mktemp -d svg-XXXXXX`
# make it world accessible
chmod a+rx $svg

# update the local curl git repo
git up -q

# update the stats scripts
(cd stats && git up -q)

# update the github issue cache
(cd stats && ./github-cache.pl)

# generate SVG files
make -j8 -f stats/Makefile GDIR=$svg DDIR=$svg WDIR=$orgdir

# remove old SVG images and tmp files
find $dir -type d -name "svg-*" -ctime +7 | xargs rm -rf

# back to base
cd $orgdir

./mkdash.pl "dash/$svg" > dash.gen
make

