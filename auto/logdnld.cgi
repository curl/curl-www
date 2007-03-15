#!/usr/bin/perl

# $Id$

use strict;

require "CGI.pm";
require "../curl.pm";

my $req = new CGI;

my $id = "";
my $year = "";
my $month = "";
my $day = "";

my $fname = $req->path_info();

# Strip invalid characters from single build log filename
$fname =~ s/[^-0-9_a-zA-Z\.]//g;

sub logdnld_file_not_found {
    print "Content-Type: text/html\n\n";
    header("Autobuilds - single log download");
    where("Autobuilds", "/auto", "Log From $year-$month-$day",
          "/auto/log.cgi?id=$id", "Download");
    title("Download log from $year-$month-$day");
    print "File not found!";
    &catfile("foot.html");
}

# Validate single build log filename format
if($fname =~ /^build-(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)-(\d+)\.log$/) {
    my ($bhour, $bmin, $bsec, $bpid);
    ($year, $month, $day, $bhour, $bmin, $bsec, $bpid)=
        ($1, $2, $3, $4, $5, $6, $7);
    $id = "$year$month$day$bhour$bmin$bsec-$bpid";
}
else {
    logdnld_file_not_found();
    exit(0);
}

my $build = "inbox/$fname";

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
else {
    logdnld_file_not_found();
    exit(0);
}

