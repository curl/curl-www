#!/usr/bin/perl

require "CGI.pm";

use strict;
require "../curl.pm";
require "ccwarn.pm";

my $req = new CGI;

my $year=$req->param('year');
my $month=$req->param('month');
my $day=$req->param('day');
my $inname=$req->param('name');
my $indate=$req->param('date');

my $id=$req->param('id');
# Strip any unsafe log name characters
$id =~ s/[^-0-9_a-zA-Z]//g;

my @out;

if($id =~ /^(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)-(\d+)/) {
    my ($bhour, $bmin, $bsec, $bpid);
    ($year, $month, $day, $bhour, $bmin, $bsec, $bpid)=
        ($1, $2, $3, $4, $5, $6, $7);
}

print "Content-Type: text/html\n\n";

header("Autobuilds - single log");
where("Autobuilds", "/auto", "Log From $year-$month-$day");
title("Log from $year-$month-$day");

#print "year $year month $month day $day name $inname date $indate";

my $date;
my $name;
my @present;

my $show=0;
my $thisid;

my $build = "inbox/build-$id.log";

my $num;

open(FILE, "<$build") || print "file not found!";

&initwarn();

while(<FILE>) {
    if($_ =~ /^testcurl: STARTING HERE/) {
        @present="";
        next;
    }
    elsif($_ =~ /^(INPIPE: endsingle here|testcurl: ENDING HERE)/) {
        last;
    }
    if($_ =~ /^testcurl: NAME = (.*)/) {
        $name = $1;
    }
    elsif($_ =~ /^testcurl: date = (.*)/) {
        $date = $1;
    }

    push @present, $_;
}

push @out, "\n<div class=\"mini\">\n";
for(@present) {
    chomp;
    if(checkwarn($_) || ($_ =~ /FAILED/)) {
        $num++;
        push @out, "<a name=\"prob$num\"></a><div class=\"warning\">" . CGI::escapeHTML($_) . "</div>\n";
    }
    else {
        push @out, CGI::escapeHTML($_) . "<br>\n";
    }
}
push @out, "</div>\n"; # end of mini-div

close(FILE);

if($out[0]) {
    if($num) {
        print "jump down to ";
        print "<a href=\"#prob1\">problem 1</a>\n";
        if($num>1) {
            print "<a href=\"#prob$num\">problem $num (last)</a>\n";
        }
    }
    print @out;
}


&catfile("foot.html");

