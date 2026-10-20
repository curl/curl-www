#!/bin/sh

# get the cert and create ca-bundle.crt
# strip off two emSign certs (2026-10-20 news)
perl ../cvssource/scripts/mk-ca-bundle.pl -x '125609AA301DA0A249B97A8239CB6A34216F44DCAC9F3954B14292F2E8C8608F,BC4D809B15189D78DB3E1D8CF4F9726A795DA1643CA5F1358E1DDB0EDC0D7EB3'

sha256sum -c cacert.pem.sha256
if test $? -gt "0"; then
  # PEM was updated, save this by date
  d="$(date +%Y-%m-%d)"
  cp cacert.pem "cacert-${d}.pem"
  sha256sum cacert.pem > cacert.pem.sha256
  sed "s/cacert\.pem/cacert-${d}.pem/" < cacert.pem.sha256 > "cacert-${d}.pem.sha256"
  gzip -c cacert.pem > cacert.pem.gz
  xz -c cacert.pem > cacert.pem.xz
  ./listpem.pl > pemlist.gen
  make
fi
