#!/bin/sh
FILE=cacert.pem-foo
perl ./mk-ca-bundle.pl -u $FILE

if [ -s $FILE ]; then
  mv $FILE cacert.pem
  gzip -c cacert.pem > cacert.pem.gz
  bzip2 -c cacert.pem > cacert.pem.bz2
fi
