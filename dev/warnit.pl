#!/usr/bin/perl

use strict;
use HTTP::Date;

require "../curl.pm";
require "./ccwarn.pm";

my $log = $ARGV[0];


if(open(my $logfile, "<$log")) {
    &initwarn();
    while(my $line = <$logfile>) {
        if(checkwarn($line)) {
            print "WARN: $line";
        }
    }
    close($logfile);    
}
