#!/bin/ksh
PATH=/usr/bin:/usr/local/bin:/bin:/opt/bin export PATH

MIRROR_DIR=/virtual/cubic.ch/www/html/mirror/curl export MIRROR_DIR
REMOTE_URL=http://curl.haxx.se/download export REMOTE_URL

echo "`date` Starting mirroring $REMOTE_URL to $MIRROR_DIR"
cd $MIRROR_DIR
OLDLIST="`ls $MIRROR_DIR`" export OLDLIST
NEWLIST="`curl -s $REMOTE_URL/curldist.txt`" export NEWLIST
for file in $NEWLIST
do
	if [ ! "`echo $OLDLIST | grep $file`" ] || [ $file = curldist.txt ] || [ $file = README.curl ]
	then
		# File is new, get it
		printf "Getting remote file $file ... "
		curl -Os $REMOTE_URL/$file
		printf "done\n"
	fi
done
for file in $OLDLIST
do
	if [ ! "`echo $NEWLIST | grep $file`" ]
	then
		# File is not present on the server, delete it
		printf "Deleting obsolete local file $file ... "
		rm -f $file
		printf "done\n"
	fi
done
