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

for my $s (keys %svg) {
    my $alt = $s;
    $alt =~ s/-/ /g;
    printf "<a id=\"%s\" href=\"dashboard1.html#%s\"><img alt=\"%s\" class=\"dash\" src=\"$dir/%s\"></a>\n",
        $s, $s, $alt, $svg{$s};
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

for my $s (keys %svg) {
    my $alt = $s;
    $alt =~ s/-/ /g;
    printf "<h2 style=\"clear: both;\">%s data</h2><a id=\"%s\" href=\"dash/%s\"><img alt=\"%s\" class=\"dash\" src=\"$dir/%s\" style=\"float: left;\"></a>\n",
        $s, $s, $data{$s}, $alt, $svg{$s};

    print "<pre>\n";
    open(C, "<dash/$data{$s}");
    my $c=0;
    while(<C>) {
        print $_;
        if($c++ >= 8) {
            last;
        }
    }
    close(C);
    print "</pre>\n";
}

print <<BOTTOM
#endif
BOTTOM
    ;
