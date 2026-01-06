#!/bin/sh
# Copyright (C) Viktor Szakats
#
# SPDX-License-Identifier: curl

# requires rsvg-convert, imagemagick, svgcleaner, svgo, scour, libxml2-utils

set -eu

if [ -f curl-logo-in.svg ]; then
  # curl-logo-raw.svg -> open in Inkscape, merge paths of the same color (Path -> Union), ungroup everything, save -> curl-logo-in.svg
  svgcleaner curl-logo-in.svg curl-logo-tmp1.svg
  svgo curl-logo-tmp1.svg
  xmllint --format curl-logo-tmp1.svg > curl-logo.svg
  rm -f curl-logo-tmp1.svg
  # edit curl-logo.svg to remove XML prolog, width/height attributes from svg tag, evenodd group, then indent to 1 space.
fi

rsvg-convert --width 2000 --keep-aspect-ratio curl-logo.svg --output curl-transparent.png
rsvg-convert --width 2000 --keep-aspect-ratio curl-logo.svg --output curl-logo.png --background-color '#ffffff'
magick curl-logo.png curl-logo.jpg

if [ -f curl-symbol-in.svg ]; then
  # curl-symbol-raw.svg -> open in Inkscape, merge paths of the same color (Path -> Union), ungroup everything, save -> curl-symbol-in.svg
  svgcleaner curl-symbol-in.svg curl-symbol-tmp1.svg
  svgo curl-symbol-tmp1.svg
  xmllint --format curl-symbol-tmp1.svg > curl-symbol.svg
  rm -f curl-symbol-tmp1.svg
  # edit curl-symbol.svg to remove XML prolog, width/height attributes from svg tag, evenodd group, then indent to 1 space.
fi

sed -E 's/#[a-f0-9]{6}/#fff/g' < curl-symbol.svg > curl-white-symbol.svg

rsvg-convert --width 672 --keep-aspect-ratio curl-symbol-raw.svg --output curl-symbol-transparent.png
rsvg-convert --width 672 --keep-aspect-ratio curl-symbol-raw.svg --output curl-symbol.png --background-color '#ffffff'
magick curl-symbol.png curl-symbol.jpg

rsvg-convert --width 2500 --keep-aspect-ratio curl-up.svg --output curl-up.png

# NOTE: Make sure to further losslessly compress the bitmaps.
