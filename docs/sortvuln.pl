#!/usr/bin/perl

require "./vuln.pm";

for my $l (@vuln) {
    my ($id, $start, $stop, $desc, $cve, $announce, $report,
        $cwe, $award, $area, $cissue, $tool, $severity, $url)=split('\|', $l);
    $when{$announce} .= "$cve,";
    $got{$cve} = $report;
    $full{$cve} = $l;
}

print <<END
# page
# first vulnerable version
# last vulnerable version
# name
# CVE
# announce date (YYYYMMDD)
# report to the project date (YYYYMMDD),
# CWE
# award money (USD)
# area (single word)
# C-issue (-, OVERFLOW, OVERREAD, DOUBLE_FREE, USE_AFTER_FREE, NULL_MISTAKE,
#          UNINIT, BAD_FREE)
# tool/lib: both, lib, tool
# severity: low, medium, high, critical
# issue: URL to the original report
#
# List of CWEs => https://cwe.mitre.org/data/definitions/658.html
\@vuln = (
END
    ;

sub cvesort {
    my $rc = $got{$b} cmp $got{$a};
    if(!$rc) {
        # same report date, sort per CVE number
        my ($ayear, $anum) = $a =~ /^CVE-(\d+)-(\d+)$/;
        my ($byear, $bnum) = $b =~ /^CVE-(\d+)-(\d+)$/;
        return ($byear <=> $ayear) || ($bnum <=> $anum);
    }
    return $rc;
}

for my $w (reverse sort keys %when) {
    my @cve = split(/,/, $when{$w});

    # these CVEs were announced on the same date, sort these per report date
    for my $c (sort cvesort @cve) {
        printf "    \"%s\",\n", $full{$c};
    }
}

print <<END
    );
END
    ;
