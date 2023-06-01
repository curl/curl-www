#!/usr/bin/perl

require "./vuln.pm";

print "<table>\n";

print <<HEAD
<tr class=\"tabletop\">
<th>#</th>
<th>S</th>
<th>Vulnerability</th>
<th>Date</th>
<th>First</th>
<th>Last</th>
</tr>
HEAD
    ;

sub cve2severity {
    my ($cve) = @_;
    open(C, "$cve.md");
    while(<C>) {
        if(/^Severity: (.*)/) {
            my $sev = $1;
            $sev =~ s/[\r\n]+//g;
            return ucfirst($sev);
        }
    }
    close(C);
    return "";
}

sub sev2color {
    my ($sev) = @_;
    my $col;
    my $sym;
    if(!$sev) {
        return "";
    }
    elsif($sev =~ /^Low/i) {
        $col = "green";
        $sym = "L";
    }
    elsif($sev =~ /^Medium/i) {
        $col = "orange";
        $sym = "M";
    }
    else {
        $col = "red";
        $sym = "H";
    }
    return "<div style=\"color: white; border-radius: 8px; background: $col; text-align: center;\">$sym</div>";
}

my $num = $#vuln + 1;
for(@vuln) {
    my ($id, $start, $stop, $desc, $cve, $date, $project, $cwe)=split('\|');
    my $year, $mon, $day;

    if($date =~ /^(\d\d\d\d)(\d\d)(\d\d)/ ) {
        ($year, $mon, $day)=($1, $2, $3);
    }

    my $sev = cve2severity($cve);
    my $col;
    $c = sev2color($sev);
    my $sevcol="<td></td>";
    if($sev) {
        $sevcol = "<td title=\"Severity $sev\">$c</td>";
    }
        
    
    print <<VUL
<tr>
<td>$num</td>
$sevcol
<td><a href="$id">$cve: $desc</a></td>
<td>$year-$mon-$day</td>
<td><a href="vuln-$start.html">$start</a></td>
<td><a href="vuln-$stop.html">$stop</a></td>
</tr>
VUL
;
    $num--;
}

print "</table>\n";
