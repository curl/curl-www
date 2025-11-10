#!/usr/bin/env perl

# un-preprocessed _changes-file as input

require "./vuln.pm";

sub vernum {
    my ($ver)=@_;
    my @v = split('\.', $ver);
    return ($v[0] << 16) | ($v[1] << 8) | $v[2];
}

my @vname; # number + HTML links to each vulnerability page
sub head {
    my $v=1;
    for(@vuln) {
        my ($id, $start, $stop, $desc, $cve, $announce, $report,
            $cwe, $award, $area, $cissue, $tool, $severity)=split('\|');

        $id =~ s/ //;
        my $num = $#vuln - $v + 2;
        $vhref[$v-1]=$a;
        $vstart[$v-1]=$start;
        $vstop[$v-1]=$stop;
        $vurl[$v-1]= "$id";
        $vulndesc[$v-1]=$desc;
        $cve[$v-1]=$cve;
        $cwe[$v-1]=$cwe;
        $sev[$v-1]=$severity;
        $v++;
    }
    return $v-1;
}


sub single {
    my ($sum, $str, $date, $vernum, $vulns, $nextrel, $prevrel) = @_;

    # make a nice HTML list to include in the page
    my @v = split(/ /, $vulns);
    my $vulnnum=scalar(@v);

    print "$str: $vulnnum\n";
}

my $l;

while(<STDIN>) {
    if($_ =~ /^SUBTITLE\(Fixed in ([0-9.]*) - (.*)\)/) {
        my $str=$1;
        my $date=$2;
        my $this = vernum($str);

        push @releases, $str;

        $reldate{$str}=$date;
        $vernum{$str}=$this;

        my $i=0;
        # Count how many versions each vuln applies to
        for(@vuln) {
            my ($id, $start, $stop)=split('\|');

            if(($this >= vernum($start)) &&
               ($this <= vernum($stop))) {
                # this version is vulnerable, count it per vuln
                $vercount[$i]++; # this applies
                $vervuln{$str} .= "$i ";
            }
            $i++;
        }
    }
}

$versions = scalar(@releases);

for my $str (@releases) {
    single($sum, $str, $date, $this, $vervuln{$str},
           $releases[$l-1], $releases[$l+1]);
}
