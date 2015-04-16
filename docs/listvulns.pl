#!/usr/bin/perl

require "vuln.pm";
require "../date.pm";

print "<table>\n";

print <<HEAD
<tr class=\"tabletop\">
<th>Vulnerability</th>
<th>Date</th>
<th>First</th>
<th>Last</th>
<th>CVE</th>    
</tr>
HEAD
    ;

            
for(@vuln) {
    my ($id, $start, $stop, $desc, $cve, $date)=split('\|');
    my $year, $mon, $day;
    my $monn;
    
    if($cve eq "-") {
        $cvestr = "[missing]";
    }
    else {
        $cvestr = "<a href=\"http://cve.mitre.org/cgi-bin/cvename.cgi?name=$cve\">$cve</a>";
    }

    if($date =~ /^(\d\d\d\d)(\d\d)(\d\d)/ ) {
        ($year, $mon, $day)=($1, $2, $3);
        $monn = ucfirst(MonthName($mon));
    }
    
    print <<VUL
<tr>
<td><a href="$id">$desc</a></td>
<td>$monn $day, $year</td>
<td>$start</td>
<td>$stop</td>
<td>$cvestr</td>
</tr>
VUL
;
}

print "</table>\n";

