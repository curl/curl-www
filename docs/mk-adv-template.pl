#!/usr/bin/perl

my $want = $ARGV[0];
if(!$want) {
    print "specify which advisory HTML file you want to generate!\n";
    exit;
}

require "./vuln.pm";
require "./novuln.pm";

my %md;
while(<stdin>) {
    push @md, $_;
}

if($#md < 10) {
    print stderr "suspiciously small markdown!\n";
    exit;
}

# add the retracted ones too
push @vuln, @novuln;

for(@vuln) {
    my ($id, $start, $stop, $desc, $cve, $announce, $report, $cwe,
        $award, $area, $cissue, $part, $sev, $issue)=split('\|');
    if($id eq $want) {
        my $markdown = join("", @md);
        my $dissue;
        my $daward;
        if($issue) {
            $dissue = "#define FLAWISSUE $issue\n";
        }
        if($award > 0) {
            $daward = "#define FLAWAWARD $award\n";
        }
        print <<TEMPLATE
#include "_doctype.html"
#define FLAWNAME $desc
#define FLAWCVE $cve
$dissue
$daward

<html>
<head> <title>curl - FLAWNAME - FLAWCVE</title>
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

ADVISORY_WHERE

#include "adv-related-box.inc"
#ifdef FLAWAWARD
<div class="relatedbox">
Awarded FLAWAWARD USD<br>
</div>
#endif

<h2>FLAWCVE</h2>
$markdown
#include "_footer.html"
</body> </html>

TEMPLATE
            ;
        last;
    }
}
