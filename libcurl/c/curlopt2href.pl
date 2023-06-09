#!/usr/bin/perl
#
# Convert various "bare" mentions of curl symbols into links.  This primarily
# adds links to the example sections which otherwise are hard to highlight
# correctly in nroff syntax.
#

while(<STDIN>) {
    # skip if preceded by letters making it likely to be a link
    $_ =~ s/([^\">\/])(CURL(OPT|INFO|MOPT|SHOPT)_[A-Z_0-9]+)/$1<a href="$2.html">$2<\/a>/g;
    # also linkify libcurl function calls
    $_ =~ s/([^\">\/]|^)(curl_(url|ws|pushheader|global|version|slist|share|mime|easy|curl|multi)_[a-z_]*)(\()/$1<a href="$2.html">$2<\/a>$4/g;
    $_ =~ s/([^\">\/]|^)(curl_(url|getenv|strequal|strnequal|getdate|formfree|formadd|formget|free|escape|unescape|version|mprintf))(\()/$1<a href="$2.html">$2<\/a>$4/g;
    $_ =~ s/([^\">\/]|^)(curl_(mfprintf|msprintf|msnprintf|mvprintf|mvfprintf|mvsprintf|mvsnprintf|maprintf|mvaprintf))(\()/$1<a href="curl_mprintf.html">$2<\/a>$4/g;
    print $_;
}

# |mfprintf|msprintf|msnprintf|mvprintf|mvfprintf|mvsprintf|mvsnprintf|maprintf|mvaprintf
