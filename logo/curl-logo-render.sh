#!/bin/sh
# Copyright (C) Viktor Szakats
#
# SPDX-License-Identifier: curl

# requires rsvg-convert, imagemagick, svgcleaner, svgo, jpegoptim, mozjpeg, advpng

set -eu

if [ -f curl-logo-in.svg ]; then
  # curl-logo-raw.svg -> open in Inkscape, merge paths of the same color (Path -> Union), ungroup everything, save -> curl-logo-in.svg
  svgcleaner curl-logo-in.svg curl-logo-tmp1.svg
  svgo --pretty --indent 1 curl-logo-tmp1.svg
  mv curl-logo-tmp1.svg curl-logo.svg
  # edit curl-logo.svg to remove width/height attributes from svg tag, evenodd group.
fi

rsvg-convert --width 2000 --keep-aspect-ratio curl-logo.svg --output curl-transparent.png
rsvg-convert --width 2000 --keep-aspect-ratio curl-logo.svg --output curl-logo.png --background-color '#ffffff'
magick curl-logo.png curl-logo.jpg

if [ -f curl-symbol-in.svg ]; then
  # curl-symbol-raw.svg -> open in Inkscape, merge paths of the same color (Path -> Union), ungroup everything, save -> curl-symbol-in.svg
  svgcleaner curl-symbol-in.svg curl-symbol-tmp1.svg
  svgo --pretty --indent 1 curl-symbol-tmp1.svg
  mv curl-symbol-tmp1.svg curl-symbol.svg
  # edit curl-symbol.svg to remove width/height attributes from svg tag, evenodd group.
fi

sed -E 's/#[a-f0-9]{6}/#fff/g' < curl-symbol.svg > curl-white-symbol.svg

rsvg-convert --width 672 --keep-aspect-ratio curl-symbol.svg --output curl-symbol-transparent.png
rsvg-convert --width 672 --keep-aspect-ratio curl-symbol.svg --output curl-symbol.png --background-color '#ffffff'
magick curl-symbol.png curl-symbol.jpg

rsvg-convert --width 2500 --keep-aspect-ratio curl-up.svg --output curl-up.png

rsvg-convert --width 2000 --keep-aspect-ratio wcurl-logo.svg --output wcurl-logo.png

# Further losslessly compress bitmaps:

for f in ./*.jpg; do
  jpegoptim --quiet --preserve --preserve-perms --all-normal --force "$f"
  /opt/homebrew/opt/mozjpeg/bin/jpegtran -optimize -copy all -outfile "$f.tmp1" "$f"; mv "$f.tmp1" "$f"
done

# This compressor alone gave better results than running a bunch of others beforehand
# (except with curl-logo.png, which was 24 bytes (0.0046%) smaller that way, and also
# significantly slower):
for f in ./*.png; do
  advpng -z -4 "$f" || true
done
