#!/usr/bin/perl
#
# Convert various "bare" mentions of curl symbols into links. This primarily
# adds links to the example sections which otherwise are hard to highlight
# correctly in nroff syntax.
#

while(<STDIN>) {
    # The debug function defines are *badly* reusing the same prefix as the
    # options for curl_easy_getinfo, so special-case them in a separate regex
    # first. Skip if preceded by letters making it likely to be a link
    $_ =~ s/([^\">\/])(CURLINFO_(TEXT|HEADER_IN|HEADER_OUT|DATA_IN|DATA_OUT|SSL_DATA_IN|SSL_DATA_OUT|END))/$1<a href="CURLOPT_DEBUGFUNCTION.html#DESCRIPTION">$2<\/a>/g;
    # skip if preceded by letters making it likely to be a link
    $_ =~ s/([^\">\/])(CURL(OPT|INFO|MOPT|SHOPT|MINFO)_[A-Z_0-9]+)/$1<a href="$2.html">$2<\/a>/g;
    # also linkify libcurl function calls
    $_ =~ s/([^\">\/]|^)(curl_(url|ws|pushheader|global|version|slist|share|mime|easy|curl|multi)_[a-z_]*)(\()/$1<a href="$2.html">$2<\/a>$4/g;
    $_ =~ s/([^\">\/]|^)(curl_(url|getenv|strequal|strnequal|getdate|formfree|formadd|formget|free|escape|unescape|version|mprintf))(\()/$1<a href="$2.html">$2<\/a>$4/g;
    $_ =~ s/([^\">\/]|^)(curl_(mfprintf|msprintf|msnprintf|mvprintf|mvfprintf|mvsprintf|mvsnprintf|maprintf|mvaprintf))(\()/$1<a href="curl_mprintf.html">$2<\/a>$4/g;
    $_ =~ s/([78]\.\d+[.0-9]*[0-9])/<a href="\/ch\/$1.html">$1<\/a>$2/g;
    print $_;
}

# |mfprintf|msprintf|msnprintf|mvprintf|mvfprintf|mvsprintf|mvsnprintf|maprintf|mvaprintf
