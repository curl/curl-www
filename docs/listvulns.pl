#!/usr/bin/perl

require "./vuln.pm";
require "../date.pm";

print "<table>\n";

print <<HEAD
<tr class=\"tabletop\">
<th>#</th>
<th>Vulnerability</th>
<th>Date</th>
<th>First</th>
<th>Last</th>
<th>CVE</th>
<th>CWE</th>
</tr>
HEAD
    ;

my $num = $#vuln + 1;
for(@vuln) {
    my ($id, $start, $stop, $desc, $cve, $date, $project, $cwe)=split('\|');
    my $year, $mon, $day;
    my $monn;

    if($cve eq "-") {
        $cvestr = "[missing]";
    }
    else {
        $cvestr = "<a href=\"https://cve.mitre.org/cgi-bin/cvename.cgi?name=$cve\">$cve</a>";
    }
    my $cwestr;
    if($cwe) {
        my $n = $cwe;
        if($n =~ /^CWE-(\d+)/) {
            $n = $1;
        }
        $cwestr = "<a href=\"https://cwe.mitre.org/data/definitions/$n.html\">$cwe</a>";
    }

    if($date =~ /^(\d\d\d\d)(\d\d)(\d\d)/ ) {
        ($year, $mon, $day)=($1, $2, $3);
        $monn = ucfirst(MonthName($mon));
    }

    print <<VUL
<tr>
<td>$num</td>
<td><a href="$id">$desc</a></td>
<td>$monn $day, $year</td>
<td><a href="vuln-$start.html">$start</a></td>
<td><a href="vuln-$stop.html">$stop</a></td>
<td>$cvestr</td>
<td>$cwestr</td>
</tr>
VUL
;
    $num--;
}

print "</table>\n";
