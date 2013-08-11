#!/bin/sh

# get the cert and create ca-bundle.crt
perl ../cvssource/lib/mk-ca-bundle.pl

bzip2 -c cacert.pem > cacert.pem.bz2
gzip -c cacert.pem > cacert.pem.gz

