#!/usr/bin/perl

require "CGI.pm";

my $p = CGI::param('p');

open(L, "<latest.txt");
my @all=<L>;
close(L);
my $v = $all[0];
chomp $v;

# keep digits, dot, dash and lowercase letters
$p =~ s/[^0-9a-z.-]//g;

print "Location: https://curl.se/windows/dl-$v/curl-$v-$p\n\n";
