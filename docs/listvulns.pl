#!/usr/bin/perl

require "./vuln.pm";

my $bar=$ARGV[0]; # the lowest severity to include
my $barlvl = severity2level($bar); # numerical level to include

print "<table>\n";

print <<HEAD
<tr class=\"tabletop\">
<th title="Vulnerability number">#</th>
<th title="Severity: L=Low, M=Medium, H=High, C=Critical">S</th>
<th title="Where: Tool-only, Lib-only, default means both">W</th>
<th title="C mistake or not">C</th>
<th>Vulnerability</th>
<th title="Date publicly disclosed">Published</th>
<th title="First curl version affected">First</th>
<th title="Last curl version affected">Last</th>
<th title="Bug-bounty award">Awarded</th>
</tr>
HEAD
    ;

# provide severity in lowercase
sub severity2level {
    my ($severity) = @_;
    return 1 if($severity eq "medium");
    return 2 if($severity eq "high");
    return 3 if($severity eq "critical");
    return 0;
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
        $col = "blue";
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

sub cdetail {
    my ($cissue) = @_;
    if($cissue ne "-") {
        my $sym = "<div style=\"color: $col; border-radius: 12px; border: 2px black dotted; text-align: center;\">C</div>";
        return "<td title=\"C mistake: $cissue\">$sym</td>";
    }
    return "<td></td>";
}

sub bounty {
    my ($usd) = @_;
    return "<td>$usd USD</td>" if($usd > 0);
    return "<td></td>";
}

my $num = $#vuln + 1;
for(@vuln) {
    my ($id, $start, $stop, $desc, $cve, $date, $project,
        $cwe, $award, $area, $cissue, $tool, $severity)=split('\|');
    my $year, $mon, $day;

    if(severity2level($severity) < $barlvl) {
        $num--;
        next;
    }

    if($date =~ /^(\d\d\d\d)(\d\d)(\d\d)/ ) {
        ($year, $mon, $day)=($1, $2, $3);
    }

    my $sev = ucfirst($severity);
    my $col;
    $c = sev2color($sev);
    my $sevcol="<td></td>";
    if($sev) {
        $sevcol = "<td title=\"Severity $sev\">$c</td>";
    }
    my $toolcol = where($tool);
    my $ccol = cdetail($cissue);
    my $bcol = bounty($award);

    print <<VUL
<tr>
<td>$num</td>
$sevcol
$toolcol
$ccol
<td><a href="$id">$cve: $desc</a></td>
<td>$year-$mon-$day</td>
<td><a href="vuln-$start.html">$start</a></td>
<td><a href="vuln-$stop.html">$stop</a></td>
$bcol
</tr>
VUL
;
    $num--;
}

print "</table>\n";
