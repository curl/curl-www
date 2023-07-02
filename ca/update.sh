#!/bin/sh

# fixup
for f in cacert-*.pem; do
  if grep -q -F '.sha256' "${f}.sha256"; then
    sed -i.bak2 's/\.sha256//' "${f}.sha256"
  fi
done

# get the cert and create ca-bundle.crt
perl ../cvssource/scripts/mk-ca-bundle.pl

sha256sum -c cacert.pem.sha256
if test $? -gt "0"; then
  # PEM was updated, save this by date
  d="$(date +%Y-%m-%d)"
  cp cacert.pem "cacert-${d}.pem"
  sha256sum cacert.pem > cacert.pem.sha256
  sed "s/cacert\.pem/cacert-${d}.pem/" < cacert.pem.sha256 > "cacert-${d}.pem.sha256"
  gzip -c cacert.pem > cacert.pem.gz
  xz -c cacert.pem > cacert.pem.xz
  perl ./listpem.pl > pemlist.gen
  make
fi
