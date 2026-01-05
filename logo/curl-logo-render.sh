#!/bin/sh
# Copyright (C) Viktor Szakats
#
# SPDX-License-Identifier: curl

# requires rsvg-convert, imagemagick, svgcleaner, svgo, scour, libxml2-utils

set -eu

rsvg-convert --width 2000 --keep-aspect-ratio curl-logo.svg --output curl-transparent.png
rsvg-convert --width 2000 --keep-aspect-ratio curl-logo.svg --output curl-logo.png --background-color '#ffffff'
magick curl-logo.png curl-logo.jpg

rsvg-convert --width 672 --keep-aspect-ratio curl-symbol-raw.svg --output curl-symbol-transparent.png
rsvg-convert --width 672 --keep-aspect-ratio curl-symbol-raw.svg --output curl-symbol.png --background-color '#ffffff'
magick curl-symbol.png curl-symbol.jpg

rsvg-convert --width 2500 --keep-aspect-ratio curl-up.svg --output curl-up.png

exit

# NOTE: Make sure to further losslessly compress the bitmaps.

# curl-symbol-raw.svg -> open in Inkscape, merge paths of the same color, ungroup everything, save -> curl-symbol-in.svg
svgcleaner curl-symbol-in.svg curl-symbol-tmp1.svg
svgo curl-symbol-tmp1.svg
xmllint --format curl-symbol-tmp1.svg > curl-symbol-tmp2.svg
scour \
  --set-precision 7 \
  --strip-xml-prolog \
  --create-groups \
  --enable-comment-stripping \
  --enable-id-stripping \
  --enable-viewboxing \
  --indent=space \
  --remove-metadata \
  --renderer-workaround \
  --shorten-ids \
  curl-symbol-tmp2.svg > curl-symbol.svg
rm -f curl-symbol-tmp*.svg

sed -E 's/#[a-f0-9]{6}/#fff/g' < curl-symbol.svg > curl-white-symbol.svg
