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

for my $s (keys %svg) {
    my $alt = $s;
    $alt =~ s/-/ /g;
    printf "<a id=\"%s\" href=\"dashboard1.html#%s\"><img alt=\"%s\" class=\"dash\" src=\"$dir/%s\"></a>\n",
        $s, $s, $alt, $svg{$s};
}
