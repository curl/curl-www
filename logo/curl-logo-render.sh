#!/bin/sh
# Copyright (C) Viktor Szakats
#
# SPDX-License-Identifier: curl

# requires rsvg-convert, imagemagick, svgo, jpegoptim, mozjpeg, advpng

set -eu

# curl-logo-master.svg -> open in Inkscape, merge 'curl' letter paths (Path -> Union), save -> curl-logo-in.svg
f='curl-logo'
if [ -f "$f"-in.svg ]; then
  svgo --pretty --indent 1 "$f"-in.svg
  mv "$f"-in.svg "$f".svg
  # manually optimize style="fill:#012345" to fill="#012345"
fi

rsvg-convert --width 2000 --keep-aspect-ratio curl-logo.svg --output curl-transparent.png
rsvg-convert --width 2000 --keep-aspect-ratio curl-logo.svg --output curl-logo.png --background-color '#ffffff'
magick curl-logo.png curl-logo.jpg

if [ ! -f curl-white-symbol.svg ]; then
  # Delete the redundant nested g stroke group after this
  sed -E 's/#[a-f0-9]{6}/#fff/g' < curl-symbol.svg > curl-white-symbol.svg
fi

rsvg-convert --width 672 --keep-aspect-ratio curl-symbol.svg --output curl-symbol-transparent.png
rsvg-convert --width 672 --keep-aspect-ratio curl-symbol.svg --output curl-symbol.png --background-color '#ffffff'
magick curl-symbol.png curl-symbol.jpg

rsvg-convert --width 2500 --keep-aspect-ratio curl-up.svg --output curl-up.png

# wcurl-logo-master.svg -> open in Inkscape, merge 'curl' letter paths (Path -> Union), save -> wcurl-logo-in.svg
f='wcurl-logo'
if [ -f "$f"-in.svg ]; then
  svgo --pretty --indent 1 "$f"-in.svg
  mv "$f"-in.svg "$f".svg
  # do the above one more time, then manually optimize style="fill:#012345" to fill="#012345"
fi

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
