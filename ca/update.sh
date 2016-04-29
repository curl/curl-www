#!/bin/sh

# get the cert and create ca-bundle.crt
perl ../cvssource/lib/mk-ca-bundle.pl

md5sum -c check
if test $? -gt "0"; then
    # PEM was updated, save this by date
    cp cacert.pem cacert-`date +%Y-%m-%d`.pem
    md5sum cacert.pem > check
    bzip2 -c cacert.pem > cacert.pem.bz2
    gzip -c cacert.pem > cacert.pem.gz
    perl ./listpem.pl > pemlist.gen
fi
