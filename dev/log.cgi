#!/usr/bin/perl -I.

# $Id$

use strict;
use HTTP::Date;

require "CGI.pm";
require "../curl.pm";
require "ccwarn.pm";

my $req = new CGI;

my $year = "";
my $month = "";
my $day = "";

my $id = $req->param('id');
# Strip any unsafe log name characters
$id =~ s/[^-\w]//g;

if($id =~ /^(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)-(\d+)/) {
    my ($bhour, $bmin, $bsec, $bpid);
    ($year, $month, $day, $bhour, $bmin, $bsec, $bpid)=
        ($1, $2, $3, $4, $5, $6, $7);
}

print "Content-Type: text/html\n";

# Allow this page to be cached for a day
print "Expires: " . time2str(time + 3600*24) . "\n\n";

header("Autobuilds - single log");
where("Autobuilds", "/dev/builds.html", "Log From $year-$month-$day");
title("Log from $year-$month-$day");

my $build = "inbox/build-$id.log";


if(open(my $logfile, "<$build")) {
    #
    &initwarn();
    #
    my @out;
    my $num = 0;
    my $state = 0;
    #
    push @out, "\n<div class=\"mini\">\n";
    #
    while(my $line = <$logfile>) {
        #
        chomp $line;
        #
        if($state) {
            if($line =~ /^testcurl: /) {
                if($line =~ /^testcurl: ENDING HERE/) {
                    last;
                }
                elsif($line =~ /^testcurl: EMAIL/) {
                    $line =~ s:\@: /at/ :g;
                }
                elsif($line =~ /^testcurl: TRANSFER CONTROL/) {
                    if($line =~ /^testcurl: .+ CHAR LINEo{1066}LINE_END/) {
                        # Don't show the transfer control line if complete
                        next;
                    }
                    $state = 2;
                }
                elsif($line =~ /^testcurl: NAME/) {
                    $state = 1;
                }
            }
            elsif($line =~ /^TESTDONE: (\d+) tests out of/) {
                push @out, "<a name=\"TESTDONE\"></a>";
            }
            if($state == 2) {
                $line =~ s/([^a-zA-Z0-9:=_]{1}?)/sprintf("[%02X]",ord($1))/ge;
            }
            #
            if(checkwarn($line) || ($line =~ /\sFAILED/) || 
               ($line =~ /MEMORY FAILURE/) || ($line =~ / at .+ line \d+\./) ||
               ($line =~ /valgrind ERROR/)) {
                $num++;
                my $nx = $num + 1;
                push @out, "<a name=\"prob$num\"></a><a href=\"#prob$nx\">goto problem $nx</a><div class=\"warning\">" . CGI::escapeHTML($line) . "</div>\n";
            }
            elsif($line =~ /^testcurl: NOTES /) {
                # Make links in NOTES lines clickable
                $line = CGI::escapeHTML($line);
                $line =~ s/((http|https|ftp|ftps):\/\/([\w\/.%=?#:@!$&*+,;~-]*[a-z0-9\/]))/<a href=\"$2:\/\/$3\" rel=\"nofollow\">$1<\/a>/g;
                push @out, $line . "<br>\n";
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
    close($logfile);
    #
    push @out, "</div>\n"; # end of mini-div
    #
    if($num) {
        print "<div>Jump down to problem:";
        my $enough = $num;
        if($enough > 30) {
            $enough = 30;
        }
        foreach my $i (1 .. $enough) {
            print "<a href=\"#prob$i\">$i</a>\n";
        }
        if($num>30) {
            print "<a href=\"#prob$num\">$num (last)</a>\n";
        }
        print "<a href=\"#TESTDONE\">test results</a>\n";
        print "</div><br>\n";
    }
    #
    print @out;
    #
    print "<div><br>\n";
    print "<a href=\"logdnld.cgi/build-$id.log\">Download build log</a>\n";
    print "</div><br>\n";
    #
}
else {
    print "\nFile not found!";
}

&catfile("foot.html");

