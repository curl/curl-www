#!/usr/bin/perl

my $dir="dash";

# here's the list of newly made graphs
open(S, "<$dir/stats.list");
while(<S>) {
    chomp;
    if($_ =~ /^(.*) = (.*)/) {
        $svg{$1} = $2;
    }
}
close(S);

print <<TOP
#ifndef DASHDATA
TOP
    ;

for my $s (sort keys %svg) {
    my $alt = $s;
    $alt =~ s/-/ /g;
    printf "<div class=\"gr\"><center>%s</center><p><a title=\"%s\" id=\"%s\" href=\"dashboard1.html#%s\"><img alt=\"%s\" class=\"dash\" src=\"$dir/%s\"></a></div>\n",
        $alt, $alt, $s, $s, $alt, $svg{$s};
}

print <<MID
#else
MID
    ;

# get the data pointers for the graphs
open(S, "<$dir/stats.data");
while(<S>) {
    chomp;
    if($_ =~ /^(.*) = (.*)/) {
        # presumable the same names as the above list
        $data{$1} = $2;
    }
}
close(S);

sub now {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
        gmtime(time);
    return sprintf "%04d-%02d-%02d %02d:%02d:%02d UTC",
        $year + 1900, $mon + 1, $mday, $hour, $min, $sec;
}

for my $s (sort keys %svg) {
    my $alt = $s;
    $alt =~ s/-/ /g;
    printf "<h2 style=\"clear: both;\">%s</h2><a id=\"%s\" href=\"dash/%s\"><img alt=\"%s\" class=\"dash\" src=\"$dir/%s\" style=\"width:40%; float: left;\"></a>\n",
        $alt, $s, $data{$s}, $alt, $svg{$s};

    print "<pre style=\"float: left;\">\n";
    open(C, "<dash/$data{$s}");
    my $c=0;
    my @end;
    my $foot = 0;
    while(<C>) {
        if($foot) {
            push @end, $_;
            if(scalar(@end) > 5) {
                shift @end;
            }
        }
        else {
            print $_;
            if($c++ >= 4) {
                print "...\n";
                $foot = 1;
            }
        }
    }
    close(C);
    print @end;
    print "</pre>\n";

    open(F, "<$dir/stats/$s.txt");
    my @h = <F>;
    close(F);
    print "<div style=\"float: left; margin-left: 10px; width: 30%;\">".join("", @h)."</div>\n";
}

print <<BOTTOM
#endif
BOTTOM
    ;

print "<br style=\"clear: both;\"> Updated ".now()."\n";
