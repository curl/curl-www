#!/bin/sh

PATH="/home/dast/linux/bin:/home/dast/bin:/usr/local/bin:/bin:/usr/bin:/usr/sbin:/sbin"

export PATH

cd $HOME/curl_html/ca

curl "http://ftp.mozilla.org/pub/mozilla.org/mozilla/nightly/latest/mozilla-source.tar.bz2" | tar -xjf - mozilla/security/nss/lib/ckfw/builtins/certdata.txt

FILE=cacert.pem-foo

./parse-certs.sh mozilla/security/nss/lib/ckfw/builtins/certdata.txt $FILE > /dev/null

if [ -s $FILE ]; then
  mv $FILE cacert.pem
  gzip -c cacert.pem > cacert.pem.gz
  bzip2 -c cacert.pem > cacert.pem.bz2
fi
