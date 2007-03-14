#!/usr/bin/perl

# $Id$

use strict;

require "CGI.pm";

my $req = new CGI;

my $fname = $req->path_info();

# Strip invalid characters from single build log filename
$fname =~ s/[^-0-9_a-zA-Z\.]//g;

# Validate single build log filename format
exit(0) unless ($fname =~ /^build-(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)-(\d+)\.log$/);

my $build = "inbox/$fname";

# Verify file exists
exit(0) unless (-f $build);

if(open(my $logfile, "<$build")) {
    #
    my $buffer;
    my $nbytes = -s $build;
    #
    binmode $logfile;
    binmode STDOUT;
    #
    print "Content-Type: application/octet-stream\n";
    print "Content-Disposition: attachment; filename=$fname\n";
    print "Content-Length: $nbytes\n\n";
    #
    while(read($logfile, $buffer, 4096)) {
        print $buffer;
    }
    #
    print "\n"; # extra LF
    #
    close($logfile);
}

