#!/usr/bin/perl

# un-preprocessed _changes-file as input

# datestamp, first vulnerable version, last vulnerable version
require "vuln.pm";            
            
sub vernum {
    my ($ver)=@_;
    my @v = split('\.', $ver);
    return ($v[0] << 16) | ($v[1] << 8) | $v[2];
}

print "<table>";
sub head {
    print "<tr class=\"tabletop\"><th>index</th><th>Version</th>";
    my $v=1;
    for(@vuln) {
        my ($id, $start, $stop, $desc)=split('\|');
        $id =~ s/ //;
        print "<th title=\"$id - $desc\"><a href=\"/docs/security.html\#$id\">#$v</a></th>";
        $v++;
    }
    print "<th>Release Date</th></tr>\n";
}

head();

my $l;

while(<STDIN>) {
    if($_ =~ /^SUBTITLE\(Fixed in ([0-9.]*) - (.*)\)/) {
        my $str=$1;
        my $date=$2;
        my $this = vernum($str);

        my @v;
        my $vnum;
        my $i;
        for(@vuln) {
            my ($id, $start, $stop)=split('\|');

            #print "CHECK $start <= $this <= $stop\n";

            if(($this >= vernum($start)) &&
               ($this <= vernum($stop))) {
                # vulnerable
                $v[$i]=1; # this one
            }
            $i++;
        }
        my $anchor = $str;

        $anchor =~ s/\./_/g;

        printf("<tr class=\"%s\"><td>%d</td><td><a href=\"/changes.html#$anchor\">$str</a></td>",
               $l&1?"even":"odd",
               $index++);
        for my $i (0 .. scalar(@vuln)-1 ) {
            printf("<td%s</td>", $v[$i]?" style=\"background-color: #f00000;\">yes":">&nbsp;");
        }
        print "<td>$date</td></tr>";

        if(!(++$l % 25)) {
            head();
        }
    }
}

print "</table>\n";
