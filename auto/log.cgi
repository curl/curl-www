#!/usr/bin/perl

require "CGI.pm";

use strict;
require "../curl.pm";
require "ccwarn.pm";

print "Content-Type: text/html\n\n";

&catfile("loghead.html");

my $req = new CGI;

my $year=$req->param('year');
my $month=$req->param('month');
my $day=$req->param('day');
my $inname=$req->param('name');
my $indate=$req->param('date');

my $id=$req->param('id');
my @out;

if($id =~ /^(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)-(\d+)/) {
    my ($bhour, $bmin, $bsec, $bpid);
    ($year, $month, $day, $bhour, $bmin, $bsec, $bpid)=
        ($1, $2, $3, $4, $5, $6, $7);
}

title("One log from $year-$month-$day");

#print "year $year month $month day $day name $inname date $indate";

my $date;
my $name;
my @present;

my $show=0;
my $thisid;

my $build = "inbox/build-$id.log";

open(FILE, "<$build");
my $num;

&initwarn();

while(<FILE>) {
    if($_ =~ /^testcurl: STARTING HERE/) {
        @present="";
        next;
    }
    elsif($_ =~ /^(INPIPE: endsingle here|testcurl: ENDING HERE)/) {
        push @out, "<div class=\"mini\">\n";
        for(@present) {
            chomp;
            if(checkwarn($_) || ($_ =~ /FAILED/)) {
                $num++;
                push @out, "<a name=\"prob$num\"></a><div class=\"warning\">$_</div>\n";
            }
            else {
                push @out, "$_<br>\n";
            }
        }
        push @out, "</div>\n"; # end of mini-div
        $show=1;
        @present="";
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
if(!$show) {
    print "Something failed, no such build was found! This probably happened",
    " because you're trying to view a log that is out of date and has ",
    " been removed. Sorry!";
}
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

