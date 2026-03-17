#!/usr/bin/env perl

my $dir=$ARGV[0];

# here's the list of newly made graphs
open(S, "<$dir/stats.list");
while(<S>) {
    chomp;
    if($_ =~ /^(.*) = (.*)/) {
        $svg{$1} = $2;
    }
}
close(S);

my $count = 0;
for my $s (sort keys %svg) {
    my $alt = $s;
    $alt =~ s/-/ /g;
    printf "<div class=\"gr\" id=\"%s\"><center>%s</center><p><a title=\"%s\" href=\"dashboard1.html#%s\"><img alt=\"%s\" class=\"dash\" src=\"dash/%s\"></a></div>\n",
        $s, $alt, $alt, $s, $alt, $svg{$s};
    $count++;
}

sub now {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
        gmtime(time);
    return sprintf "%04d-%02d-%02d %02d:%02d:%02d UTC",
        $year + 1900, $mon + 1, $mday, $hour, $min, $sec;
}

print "<br style=\"clear: both;\">$count images created at ".now()."\n";
