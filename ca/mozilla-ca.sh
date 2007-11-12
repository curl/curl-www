#!/bin/sh

PATH="/home/dast/linux/bin:/home/dast/bin:/usr/local/bin:/bin:/usr/bin:/usr/sbin:/sbin"

export PATH

cd $HOME/curl_html/ca

curl -s "http://lxr.mozilla.org/seamonkey/source/security/nss/lib/ckfw/builtins/certdata.txt?raw=1" -o certdata.txt

if $? -gt 0; then
  exit curl failed
fi

FILE=cacert.pem-foo

./parse-certs.sh certdata.txt $FILE > /dev/null

if [ -s $FILE ]; then
  mv $FILE cacert.pem
  gzip -c cacert.pem > cacert.pem.gz
  bzip2 -c cacert.pem > cacert.pem.bz2
fi
