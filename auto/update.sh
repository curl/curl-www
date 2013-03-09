#!/bin/sh

PATH="/home/dast/bin:/usr/local/bin:/bin:/usr/bin:/usr/sbin:/sbin"

export PATH

# get the open bugs RSS feed
./rssbugs.pl > bugbox.t

# update the build table
./update.pl
