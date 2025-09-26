#!/bin/sh
# Copyright (C) Viktor Szakats
#
# SPDX-License-Identifier: curl

set -eu

cd "$(dirname "${0}")"/../..

# shellcheck disable=SC2046
codespell \
  --skip '.github/scripts/spellcheck.words' \
  --skip '.github/scripts/typos.toml' \
  --skip '**/*.ai' \
  --skip '**/*.pdf' \
  --skip '**/*.svg' \
  --skip 'dev/explainopts.t' \
  --skip 'docs/_companies.html' \
  --skip 'docs/videos/videolist.txt' \
  --skip 'last20threads.pl' \
  --skip 'rfc/*.txt' \
  --skip 'rfc/cookie_spec.html' \
  --skip 'rfc/ntlm.html' \
  --ignore-words '.github/scripts/codespell-ignore.txt' \
  $(git ls-files)
