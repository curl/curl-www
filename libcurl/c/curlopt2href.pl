#!/usr/bin/perl
#
# Convert various "bare" mentions of curl symbols into links.  This primarily
# adds links to the example sections which otherwise are hard to highlight
# correctly in nroff syntax.
#

while(<STDIN>) {
    # skip if preceded by letters making it likely to be a link
    $_ =~ s/([^\">\/])(CURL(OPT|INFO|MOPT)_[A-Z_0-9]+)/$1<a href="$2.html">$2<\/a>/g;
    # also linkify libcurl function calls
    $_ =~ s/([^\">\/]|^)(curl_(easy|curl|multi)_[a-z_]*)(\()/$1<a href="$2.html">$2<\/a>$4/g;
    print $_;
}
