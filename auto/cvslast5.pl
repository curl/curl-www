#!/usr/bin/perl
#
# Copyright (C) 2002, Daniel Stenberg, <daniel@haxx.se>
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

my @out;

my $file;
my $change=0; # state
while(<STDIN>) {
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
    $changedates{$date}.= ":::$author";
    $changecomment{$date}{$author} .= ":::".join(" ", @comment);
    $changefiles{$date}{$author} .= ":::$file";
}

my $firsttime;
my $firstval;

my $lasttime;
my $lastval;
sub datemonger {
    my ($date)=@_;

    if($date =~ /(\d\d\d\d)\/(\d\d)\/(\d\d) (\d\d):(\d\d):(\d\d)/) {
        my ($year, $month, $day, $hour, $min, $sec)=($1,$2,$3,$4,$5,$6);

        my $val = $sec + $min*60+$hour*3600+ $day*3600*24 +
            $month*31*24*3600 + $year*366*24*3600;

        if($val > $lastval) {
            $lastval = $val;
            $lasttime = $date;
        }
        if(!$firstval || ($val < $firstval)) {
            $firstval = $val;
            $firsttime = $date;
        }

        $datemong{$date}=$val;
    }
}

sub showlog {
    my ($file, $log) = @_;
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
            $changecount++; # count total changes
            undef $rev, $date, $author, $lines;
            undef @comment;
        }
        else {
            push @comment, $line;
        }
    }
    singlechange($num, $file, $rev, $date, $author, $lines, @comment);
    $changecount++; # count total changes
}

for(@files) {
    if($_ =~ /^www/) {
        # ignore changes to this module
        next;
    }
    else {
        $changefiles++;
        showlog($_, $log{$_});
    }
}

if( $changecount) {

    my @c = sort { $datemong{$b} <=> $datemong{$a} } keys %changedates;
    my $i=0;

    print "<table class=\"changetable\"><tr><th>when</th><th>who</th><th>where</th><th>what</th></tr>\n";
    for(@c) {
        my $date = $_;

        if($i++ >= 15) {
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
        if ( $printdate =~ /(\d+-\d+-\d+ \d+:\d+)/ ) {
            $printdate = $1;
        }
        printf("<td nowrap>%s</td><td>\n",
               $printdate);

        my %shortnames=('bagder' => 'Daniel Stenberg');

        for(keys %hash) {
            if($_) {
                my $n = $shortnames{$_};
                if($n) {
                    print $n;
                }
                else {
                    print $_;
                }
                #print "<a href=\"http://sourceforge.net/users/$_\">$_</a>\n";
            }
        }

        print "</td><td nowrap>";

        my %files;
        for(split(":::", $changedates{$date})) {
            my $author = $_;
            for(split(":::", $changefiles{$date}{$_})) {
                my $file = $_;
                $file =~ s/ +//g;
                if($file) {
                    $files{$file}=$file;
                }
            }
        }
        for(keys %files) {
            my $file = $_;
            #my $root="http://cvs.sourceforge.net/cgi-bin/viewcvs.cgi/curl/curl";
            my $root="http://cvs.php.net/cvs.php/curl";
            printf("<a href=\"$root/%s\">%s</a><br> \n",
                           $file, $file);
        }
        print "</td><td>";

        my %comm;
        for(split(":::", $changedates{$date})) {
            my $author = $_;

            for(split(":::", $changecomment{$date}{$author})) {
  #              $_ =~ s/\n/ /g;
  #              $_ =~ s/\r//g;
  #              $_ =~ s/  / /g;
                $comm{$_}=$_;
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
