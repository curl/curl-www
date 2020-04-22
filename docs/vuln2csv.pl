#!/usr/bin/perl

require "./vuln.pm";

for(@vuln) {
    my @a=split('\|');
    $a[5] =~ s/(\d\d\d\d)(\d\d)(\d\d)/$1-$2-$3/;
    $a[6] =~ s/(\d\d\d\d)(\d\d)(\d\d)/$1-$2-$3/;
    print join(";", @a),"\n";
}
