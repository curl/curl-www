#!/usr/bin/perl

require "./vuln.pm";

print "<table>\n";

print <<HEAD
<tr class=\"tabletop\">
<th title="Vulnerability number">#</th>
<th title="Severity: L=Low, M=Medium, H=High, C=Critical">S</th>
<th title="Where: Tool-only, Lib-only, default means both">W</th>
<th>Vulnerability</th>
<th title="Date publicly disclosed">Date</th>
<th title="First curl version affected">First</th>
<th title="Last curl version affected">Last</th>
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
    elsif($sev =~ /^High/i) {
        $col = "red";
        $sym = "H";
    }
    elsif($sev =~ /^Critical/i) {
        $col = "black";
        $sym = "C";
    }
    return "<div style=\"color: $col; border-radius: 8px; border: 2px $col solid; text-align: center;\">$sym</div>";
}

sub where {
    my ($tool) = @_;
    if($tool eq "tool") {
        return "<td title=\"curl tool only\">tool</td>";
    }
    elsif($tool eq "lib") {
        return "<td title=\"libcurl only\">lib</td>";
    }

    return "<td></td>";
}

my $num = $#vuln + 1;
for(@vuln) {
    my ($id, $start, $stop, $desc, $cve, $date, $project,
        $cwe, $award, $area, $cissue, $tool)=split('\|');
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
    my $toolcol = where($tool);
    
    print <<VUL
<tr>
<td>$num</td>
$sevcol
$toolcol
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
