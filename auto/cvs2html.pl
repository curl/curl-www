#!/usr/bin/perl
#
# Copyright (C) 2002-2004, Daniel Stenberg, <daniel@haxx.se>
#
# This software is licensed as described in the file COPYING, which
# you should have received as part of this distribution.
# 
# You may opt to use, copy, modify, merge, publish, distribute and/or sell
# copies of the Software, and permit persons to whom the Software is
# furnished to do so, under the terms of the COPYING file.
#
# This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
# KIND, either express or implied.
#

# Example output ("# " prefixed lines):

# RCS file: /cvsroot/curl/apps/credits.c,v
# Working file: apps/credits.c
# head: 1.4
# branch:
# locks: strict
# access list:
# symbolic names:
# keyword substitution: kv
# total revisions: 4;	selected revisions: 1
# description:
# ----------------------------
# revision 1.4
# date: 2002/05/28 12:10:12;  author: zagor;  state: Exp;  lines: +3 -3
# Adapted to modified button_get() call
# =============================================================================

my $input;
my $css;
my $html;

if($ARGV[0] eq "-s") {
    shift @ARGV;
    $css = shift @ARGV;
}
if($ARGV[0] eq "-h") {
    shift @ARGV;
    $html = shift @ARGV;
}


sub help {
    print <<USAGE
cvs2html.pl [-s style] [-h html]<cvs dumpfile>
USAGE
;
    exit;
}

$input = $ARGV[0];

if($input eq "-h") {
    help();
}
elsif(!$input) {
    help();
}

#############################################################################
# Edit these variables:
#

my $head=0; # don't output HEAD

my $maxnumshown = 30; # only show this many

# CVS user names
my %shortnames=('bagder' => 'Daniel',
                'gknauf' => 'Günter',
                'giva'   => 'Gisle',
                'danf'   => 'Dan F',
                'curlvms' => 'Marty');

# URL root to prepend file names with
my $root="http://cool.haxx.se/cvs.cgi/curl";

#
# You should not need to edit variables below this marker
#############################################################################

my @mname = ('January',
             'February',
             'March',
             'April',
             'May',
             'June',
             'July',
             'August',
             'September',
             'October',
             'November',
             'December' );

my %datemong; # date string to numerical lookup
my %mongdate; # numerical to date string lookup

my @out;

my $file;
my $change=0; # state
open (INPUT, "<$input") ||
    die "can't read file $input";

# This loop parses the dump and splits up the changes into changes done to the
# specific files.

while(<INPUT>) {
    my $line = $_;
    if(!$change) {
        if($line =~ /^Working file: (.*)/) {
            $file = $1;
        }
        elsif($line =~ /^----------------------------/) {
            $change=1;
            push @files, $file;
        }
    }
    else {
        if($line =~ /^=============================================================================/) {
            $change = 0; # no more changes
        }
        else {
            $log{$file} .= $line;
        }
    }

}
close(INPUT);

# Store information about this one specific change done in a single file. The
# same comment (by the same author) may of course have been made from multiple
# files.

sub singlechange {
    my ($num, $file, $rev, $date, $author, $lines, @comment) = @_;
    my $count=0;

    if(!$num) {
        push @out, "\n===[ $file ]===\n";
    }
    push @out, "  $rev ($author) ";
    for(@comment) {
        if($count) {
            push @out, "               ";
        }
        push @out, "$_\n";
        $count++;
    }

    my $comm = join(" ", @comment);
    my $qcomm = quotemeta($comm);

    # Time for some magic.  Check for the same comment and the same author
    # done to another file with a datestamp close in time. If we find one, we
    # consider that to be the same actual commit as this and we thus use the
    # same timestamp for all of them.

    my $datenum = $datemong{$date}; # get the numerical version

    # check for already used dates from -5 seconds to +5 seconds from this
    # set date.

    foreach $step (1 .. 30) {
        foreach $mul ((-1, 1)) {
            my $delta = $step * $mul;
            my $dstr = $mongdate{$datenum + $delta};
            if($dstr &&
               $changedates{$dstr} =~ /:::$author/ &&
               $changecomment{$dstr}{$author} =~ /:::$qcomm/) {
                # YES, this comment and author was already used for another
                # file only $delta seconds away
                $date = $dstr;
            }
        }
    }

    $changedates{$date}.= ":::$author";
    $changecomment{$date}{$author} .= ":::$comm";
    $changefiles{$date}{$author} .= ":::$file";

    # at this time, this file reach this rev
    $revs{$date}{$file}="$rev";

    $changecount++; # count total changes
}

my $firsttime;
my $firstval;

my $lasttime;
my $lastval;


# This function takes the full string date and converts it to a suitable
# numerical version that can be used for comparisions between dates. No need
# to be an exact science.
sub datemonger {
    my ($date)=@_;

    if($date =~ /(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d)/) {
        my ($year, $month, $day, $hour, $min, $sec)=($1,$2,$3,$4,$5,$6);

        my $val = $sec + $min*60+$hour*3600+ $day*3600*24 +
            $month*31*24*3600 + ($year-1980)*380*24*3600;

        if($val > $lastval) {
            $lastval = $val;
            $lasttime = $date;
        }
        if(!$firstval || ($val < $firstval)) {
            $firstval = $val;
            $firsttime = $date;
        }

        $datemong{$date}=$val; # string to num
        $mongdate{$val}=$date; # num to string
    }
}

#
# Walk through all changes done to this single file
#
sub parselog {
    my ($file, $log) = @_;

    $log =~ s/\r//g; # remove CRs

    my @log = split("\n", $log);

    my ($rev, $date, $author, $lines, @comment);
    my $num=0;
    for(@log) {
        $line = $_;
        
        if($line =~ /^revision (.*)/) {
            $rev = $1;
        }
        elsif($line =~ /^date: ([^;]*);  author: ([^;]*);  state: ([^;]*);(.*)/) {
            ($date, $author)=($1,$2);

            if($4 =~ /lines: (.*)/) {
                $lines = $1;
            }

            datemonger($date);
        }
        elsif($line =~ /^----------------------------/) {
            # multiple commit separator
            singlechange($num, $file, $rev, $date, $author, $lines, @comment);
            $num++; # count changes done to this single file
            undef $rev, $date, $author, $lines;
            undef @comment;
        }
        else {
            push @comment, $line;
        }
    }
    singlechange($num, $file, $rev, $date, $author, $lines, @comment);
}

for(@files) {
    $changefiles++;
    parselog($_, $log{$_});
}

my @css;
if($css) {
    open(CSS, "<$css");
    @css = <CSS>;
    close(CSS);
}
my @html;
if($html) {
    open(HTML, "<$html");
    @html = <HTML>;
    close(HTML);
}

# set $head to true if this should output <HEAD>
if($head) {
    print <<HEAD
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<html>
<head>
<title>Recent CVS Changes</title>
<meta http-equiv="refresh" content="1800">
<style type="text/css">
@css
</style>
</head>
<body>
@html
HEAD
    ;
}

if( $changecount) {

    my @c = sort { $datemong{$b} <=> $datemong{$a} } keys %changedates;
    my $i=0;

    print "<table class=\"changetable\"><tr><th>when (GMT)</th><th>who</th><th>where / diff</th><th>what</th></tr>\n";
    for(@c) {
        my $date = $_;

        if($i++ >= $maxnumshown) {
            # show only the XX most recent
            last;
        }

        my $cl="even";
        if($i & 1) {
            $cl="odd";
        }
        print "<tr class=\"$cl\">\n";

        my %hash;
        for(split(":::", $changedates{$date})) {
            $hash{$_}=$_;
        }

        $printdate = $date;
        $printdate =~ s|/|-|g;
        if ( $printdate =~ /(\d+)-(\d+)-(\d+) (\d+):(\d+)/ ) {
            my ($year, $mon, $day, $hour, $min) = ($1, $2, $3, $4, $5);
            $printdate = sprintf("%d %.3s %02d:%02d",
                                 $day, $mname[$mon-1], $hour, $min);
        }
        printf("<td nowrap>%s</td><td nowrap>\n",
               $printdate);

        for(keys %hash) {
            if($_) {
                my $n = $shortnames{$_};
                if($n) {
                    print $n;
                }
                else {
                    print $_;
                }
            }
        }

        print "</td><td nowrap>";

        my %files;

        # loop over all authors for this specific date
        foreach $author (split(":::", $changedates{$date})) {

            # loop over all files this particular author changed at this date
            foreach $file (split(":::", $changefiles{$date}{$author})) {
                $file =~ s/ +//g;
                if($file) {
                    $files{$file}=$file;
                }
            }
        }
        my $loop;
        for(sort keys %files) {
            my $file = $_;
            my $r = $revs{$date}{$file};
            my $p; # attempted previous version

            if($r =~ /^(\d+)\.(\d+)$/) {
                # strict match for the simple cases!
                my ($num, $dot)=($1, $2);
                if($dot > 1) {
                    $p = sprintf("%d.%d", $num, $dot-1);

                    # viewcvs.cgi style diff URL:
                    $r = "<a href=\"$root/$file.diff?r1=$p&r2=$r\">$r</a>";
                }

            }
            printf("%s<a href=\"$root/%s\">%s</a> %s\n",
                   $loop?"<br>":"", $file, $file, $r);
            $loop++;
        }
        print "</td><td>";

        my %comm;
        # loop over all athours
        foreach $author (split(":::", $changedates{$date})) {

            # loop over all comments by this author at this date
            foreach $cmt (split(":::", $changecomment{$date}{$author})) {
                $comm{$cmt}=$cmt;
            }
        }
        my $comm = join(" ", keys %comm);

        $comm =~ s/\</&lt;/g;
        $comm =~ s/\>/&gt;/g;

        print "$comm</td></tr>\n";
    }
    print "</table>";


}
else {
    print "No changes\n";
}
