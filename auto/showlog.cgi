#!/usr/bin/perl

require "CGI.pm";

use strict;
require "../curl.pm";

print "Content-Type: text/html\n\n";

&catfile("loghead.html");

my $req = new CGI;

my $year=$req->param('year');
my $month=$req->param('month');
my $day=$req->param('day');
my $inname=$req->param('name');
my $indate=$req->param('date');

#print "year $year month $month day $day name $inname date $indate";

my $date;
my $name;
my @present;

my $show=0;

open(FILE, "<inbox/inbox$year-$month-$day.log") ||
    print "file not open";
while(<FILE>) {
    if($_ =~ /^testcurl: STARTING HERE/) {
        @present="";
        next;
    }
    elsif($_ =~ /^testcurl: ENDING HERE/) {
        if(($name eq $inname) &&
           ($indate eq $date)) {
            print "<div class=\"mini\">\n";
            for(@present) {
                chomp;
                if(
                   # gcc warning:
                   ($_ =~ /([.\/a-zA-Z0-9]*)\.[ch]:([0-9:]*): /) ||
                   # test case failure
                   ($_ =~ /FAILED/) ||
                   # the line below is adjusted for AIX xlc warnings:
                   ($_ =~ /\"([_.\/a-zA-Z0-9]+)\", line/) ||
                   # Tru64 cc warning:
                   ($_ =~ /^cc: Warning: ([.\/a-zA-Z0-9]*)/) ||
                   # MIPSPro C 7.3:
                   ($_ =~ /cc: WARNING File/) ||
                   # Intel icc 8.0:
                   ($_ =~ /: remark \#/)
                   ) {
                       print "<div class=\"warning\">$_</div>\n";
                }
                else {
                    print "$_<br>\n";
                }
            }
            print "</div>\n"; # end of mini-div
            $show=1;
            @present="";
            last;
        }
    }
    if($_ =~ /^testcurl: NAME = (.*)/) {
        $name = $1;
    }
    elsif($_ =~ /^testcurl: date = (.*)/) {
        $date = $1;
    }

    push @present, $_;
}
if(!$show) {
    print "Something failed, no such build was found!";
}
close(FILE);


&catfile("foot.html");

