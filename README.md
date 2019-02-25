# curl-www

This is (most of) the [curl.haxx.se](https://curl.haxx.se/) web site contents. It mostly builds static
HTML files that are preprocessed.

## Prerequisites

The web site is an on old custom made setup that mostly builds static HTML
files from a set of source files. The sources files are preprocessed with what
is basically a souped-up C preprocessor called `fcpp` and a set of perl
scripts. The main pages get converted to HTML with roffit. Make sure `fcpp`,
`perl`, `roffit`, `make` and `curl` are all in your `$PATH`.

# Build

Once you've cloned the git repo the first time, invoke `sh bootstrap.sh` once
to get a symlink and some some initial local files setup, and then you can
build the web site locally by invoking `make` in the source root tree.

Note that this doesn't make you a complete web site mirror, as some scripts
and files are only available on the real actual site, but should give you
enough to let you load most HTML pages locally.

# Edit the web

[Web editing guidelines](https://curl.haxx.se/web-editing.html)
