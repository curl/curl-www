#!/usr/bin/perl

require "CGI.pm";

my $num = CGI::param('i');

# remove non-digits
$num =~ s/[^0-9]//g; 

if($num > 1) {
    print "Location: https://github.com/bagder/curl/issues/$num\n\n";
}
else {
    print "Location: https://github.com/bagder/curl/issues\n\n";
}
