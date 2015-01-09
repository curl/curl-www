#!/usr/bin/perl

# un-preprocessed _changes-file as input

# datestamp, first vulnerable version, last vulnerable version
require "vuln.pm";            
            
sub vernum {
    my ($ver)=@_;
    my @v = split('\.', $ver);
    return ($v[0] << 16) | ($v[1] << 8) | $v[2];
}

my @vname; # number + HTML links to each vulernability page
print "<table>";
sub head {
    print "<tr class=\"tabletop\"><th>index</th><th>Version</th>";
    my $v=1;
    for(@vuln) {
        my ($id, $start, $stop, $desc)=split('\|');
        $id =~ s/ //;
        my $a=sprintf("<a style=\"color: blue;\" href=\"/docs/security.html\#$id\" title=\"$desc\">%02d</a>",
                      $#vuln - $v + 2);
        $vname[$v-1]=$a;
        print "<th title=\"$id - $desc\">$a</th>";
        $v++;
    }
    print "<th>Total</th>\n";
    print "<th>Release Date</th></tr>\n";
    return $v-1;
}

my $total = head();

my $l;
my $index;


while(<STDIN>) {
    if($_ =~ /^SUBTITLE\(Fixed in ([0-9.]*) - (.*)\)/) {
        my $str=$1;
        my $date=$2;
        my $this = vernum($str);
        push @releases, $str;
        $reldate{$str}=$date;
        $vernum{$str}=$this;
    }
}

for my $str (@releases) {
    my $date=$reldate{$str};
    my $this = $vernum{$str};

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
    my $col;
    my $sum;
    for my $i (0 .. $total-1 ) {
        if(!$v[$i]) {
            $col++;
        }
        else {
            if($col) {
                printf("<td colspan=%d>&nbsp;</a>", $col);
                $col=0;
            }
            printf("<td>%s</td>", $vname[$i]);
            $sum++;
        }
    }
    if($col) {
        printf("<td colspan=%d>&nbsp;</a>", $col);
    }
    printf "<td>%d</td><td>$date</td></tr>\n", $sum;
        
    ++$l;
}

print "</table>\n";
