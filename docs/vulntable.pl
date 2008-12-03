#!/usr/bin/perl

# un-preprocessed _changes-file as input

# datestamp, first vulnerable version, last vulnerable version
my @vuln = ("20070710|7.14.0|7.16.3",
            "BID17154|7.15.0|7.15.2",
            "BID15756|7.11.2|7.15.0",
            "BID15102|7.10.6|7.14.1",
            "BID12616|7.3   |7.13.0",
            "BID12615|7.10.6|7.13.0",
            "BID8432 |7.1   |7.10.6",
            "BID1804 |6.0   |7.4   ",
            );
            
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
        my ($id, $start, $stop)=split('\|');
        $id =~ s/ //;
        print "<th title=\"$id\"><a href=\"/docs/security.html\#$id\">#$v</a></th>";
        $v++;
    }
    print "<th>Release Date</th><th>Since Most Recent</th></tr>\n";
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

        my $datesecs=`date -d "$date" +%s`;
        my $daysbetween;

        if($prevsecs) {
            # number of seconds between two releases!
            my $reltime = $prevsecs - $datesecs;

            # convert to days
            $daysbetween = int($reltime/(3600*24));

            if($daysbetween < 100) {
                $age = "$daysbetween days";
            }
            elsif($daysbetween < 400) {
                $age = sprintf("%d months", int($daysbetween/30));
            }
            else {
                my $mon = int(($daysbetween%365)/30);
                $age = sprintf("%d years, %d months", 
                               int($daysbetween/365),
                               $mon);
            }
        }
        else {
            # store the first date
            $prevsecs = $datesecs;
            $age="most recent";
        }

        printf("<tr class=\"%s\"><td>%d</td><td><a href=\"/changes.html#$anchor\">$str</a></td>",
               $l&1?"even":"odd",
               $index++);
        for my $i (0 .. scalar(@vuln)-1 ) {
            printf("<td%s</td>", $v[$i]?" style=\"background-color: #f00000;\">yes":">&nbsp;");
        }
        print "<td>$date</td><td>$age</td></tr>";

        if(!(++$l % 25)) {
            head();
        }
    }
}

print "</table>\n";
