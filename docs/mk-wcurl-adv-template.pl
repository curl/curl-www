#!/usr/bin/perl

my $want = $ARGV[0];
my $cve = $want;
if(!$want) {
    print "specify which advisory HTML file you want to generate!\n";
    exit;
}
$cve =~ s/\.html$//;

my %md;
while(<stdin>) {
    push @md, $_;
}

if($#md < 10) {
    print stderr "suspiciously small markdown!\n";
    exit;
}
my $markdown = join("", @md);

        print <<TEMPLATE
#include "_doctype.html"
#define FLAWCVE $cve
$dissue
$daward

<html>
<head> <title>wcurl - FLAWCVE</title>
#include "css.t"
#include "manpage.t"
<style>
code {
    padding: 0px 4px 0px 4px;
    background-color: #f0f0f0;
}

@media (prefers-color-scheme: dark) {
    code {
        padding: 0px 4px 0px 4px;
        background-color: #101010;
    }
}
</style>
</head>

#define CURL_DOCS
#define CURL_URL docs/$want

#include "_menu.html"
#include "setup.t"
#include "advisory.t"

WHERE3(Docs, "/docs/", curl CVEs, "/docs/security.html", FLAWCVE)

#include "adv-related-box.inc"

<h2>FLAWCVE</h2>
$markdown
#include "_footer.html"
</body> </html>

TEMPLATE
            ;
