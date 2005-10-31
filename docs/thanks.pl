#!/usr/bin/perl

while(<STDIN>) {
    push @names, $_;
}

sub showcol {
    my ($c) = @_; # 0, 1, 2 or 3
    my $max = $#names;
    my $single = $max/4;
    my $start = $c*$single;
    my $end = ($start+$single);

    if($c == 3) {
        $end = $max; # prevent rounding errors
    }
    if($c) {
        $start++;
    }

    for($start .. $end) {
        print $names[$_]."<br>\n";
    }
}

# Put them all in three columns
print "<table><tr valign=\"top\"><td>\n";
showcol(0);
print "</td><td>\n";
showcol(1);
print "</td><td>\n";
showcol(2);
print "</td><td>\n";
showcol(3);
print "</td></tr></table>\n";
