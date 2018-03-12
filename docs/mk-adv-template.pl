#!/usr/bin/perl

my $want = $ARGV[0];
if(!$want) {
    print "specify which advisory HTML file you want to generate!\n";
    exit;
}

require "./vuln.pm";

my %md;
while(<stdin>) {
    push @md, $_;
}

if($#md < 10) {
    print stderr "suspiciously small markdown!\n";
    exit;
}

for(@vuln) {
    my ($id, $start, $stop, $desc, $cve, $announce, $report, $cwe)=split('\|');
    if($id eq $want) {
        my $markdown = join("", @md);
        print <<TEMPLATE
#include "_doctype.html"
#define FLAWNAME $desc

<HTML>
<HEAD> <TITLE>curl - FLAWNAME</TITLE>
#include "css.t"
#include "manpage.t"
</HEAD>

#define CURL_DOCS
#define CURL_URL docs/$want

#include "_menu.html"
#include "setup.t"
#include "advisory.t"

ADVISORY_WHERE

#include "adv-related-box.inc"
$markdown
#include "_footer.html"
</body> </html>

TEMPLATE
            ;
        last;
    }
}
