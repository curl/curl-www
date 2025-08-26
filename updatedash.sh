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

# update the local curl git repo
git up -q

# update the stats scripts
(cd stats && git up -q)

# update the github issue cache
(cd stats && ./github-cache.pl)

# debug git shortlog
git shortlog -s > tmp/git-shortlog.txt 2>&1

# generate us a bunch of updated SVG files
sh stats/mksvg.sh ..

# back to base
cd $orgdir

./mkdash.pl > dash.gen
make

# remove old SVG images
find $dir -type d -name "svg-*" -ctime +7 | xargs rm -rf
