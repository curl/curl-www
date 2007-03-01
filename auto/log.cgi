#!/usr/bin/perl

use strict;
use MIME::QuotedPrint ();

require "CGI.pm";
require "../curl.pm";
require "ccwarn.pm";

my $req = new CGI;

my $year = "";
my $month = "";
my $day = "";

my $id = $req->param('id');
# Strip any unsafe log name characters
$id =~ s/[^-0-9_a-zA-Z]//g;

if($id =~ /^(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)-(\d+)/) {
    my ($bhour, $bmin, $bsec, $bpid);
    ($year, $month, $day, $bhour, $bmin, $bsec, $bpid)=
        ($1, $2, $3, $4, $5, $6, $7);
}

print "Content-Type: text/html\n\n";

header("Autobuilds - single log");
where("Autobuilds", "/auto", "Log From $year-$month-$day");
title("Log from $year-$month-$day");

my $build = "inbox/build-$id.log";

# find out if log file is quoted-printable encoded
my $qpencoded = 0;
if(open(SCAN, "<$build")) {
    my $linecount;
    my $mimecount;
    while(<SCAN>) {
        if($_ =~ /^testcurl: [A-Z]+ =3D/) {
            if($mimecount++ > 3) {
                $qpencoded = 1;
                last;
            }
        }
        last if($linecount++ > 18);
    }
    close(SCAN);
}

my $date;
my $timestamp;
my $description;

if(open(FILE, "<$build")) {
    #
    &initwarn();
    #
    my @out;
    my $num = 0;
    my $state = 0;
    my $buffer = "";
    #
    push @out, "\n<div class=\"mini\">\n";
    #
    while(my $chunk = <FILE>) {
        my $line;
        # decode quoted-printable if encoded
        if($qpencoded) {
            $buffer .= MIME::QuotedPrint::decode_qp($chunk);
            if($buffer =~ /\n$/) {
                $line = $buffer;
                $buffer = "";
            }
            else {
                next; # chunk
            }
        }
        elsif(!$line) {
            # if not qp encoded and ref is not set yet,
            # set line as ref to chunk to avoid copy.
            $line = "@{[$chunk]}";
        }
        chomp $line;
        #
        if($state) {
            if($line =~ /^testcurl: /) {
                if($line =~ /^testcurl: ENDING HERE/) {
                    last;
                }
                elsif($line =~ /^testcurl: DESC = (.*)/) {
                    $description = $1;
                }
                elsif($line =~ /^testcurl: date = (.*)/) {
                    $date = $1;
                }
                elsif($line =~ /^testcurl: timestamp = (.*)/) {
                    $timestamp = $1;
                }
                elsif($line =~ /^testcurl: EMAIL/) {
                    $line =~ s:\@: /at/ :g;
                }
                elsif($line =~ /^testcurl: TRANSFER CONTROL/) {
                    $state = 2;
                }
                elsif($line =~ /^testcurl: NAME/) {
                    $state = 1;
                }
            }
            if($state == 2) {
                my $nlend = ($line =~ /\n$/);
                $line =~ s/([^a-zA-Z0-9:=_]{1}?)/sprintf("[%02X]",ord($1))/ge;
                $line .= "\n" if($nlend);
            }
            #
            if(checkwarn($line) || ($line =~ /FAILED/) || ($line =~ /MEMORY FAILURE/)) {
                $num++;
                push @out, "<a name=\"prob$num\"></a><div class=\"warning\">" . CGI::escapeHTML($line) . "</div>\n";
            }
            else {
                push @out, CGI::escapeHTML($line) . "<br>\n";
            }
        }
        elsif($line =~ /^testcurl: STARTING HERE/) {
            $state = 1;
            next;
        }
    }
    close(FILE);
    #
    push @out, "</div>\n"; # end of mini-div
    #
    if($num) {
        print "<div>Jump down to ";
        print "<a href=\"#prob1\">problem 1</a>\n";
        if($num>1) {
            print "<a href=\"#prob$num\">problem $num (last)</a>\n";
        }
        print "</div><br>\n";
    }
    #
    print @out;
    #
}
else {
    print "File not found!";
}

&catfile("foot.html");

