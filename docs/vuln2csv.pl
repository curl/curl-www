#!/usr/bin/perl

require "./vuln.pm";

for(@vuln) {
    my @a=split('\|');
    print join(";", @a),"\n";
}
