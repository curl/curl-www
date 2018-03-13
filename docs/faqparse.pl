#!/usr/bin/perl

require "../curl.pm";

# pass curl FAQ on stdin

# 1 - eat the TOC and remember the questions
# 2 - output the TOC with links to question-anchors
# 3 - output the questions/answers with proper <a name> tags

my $state = 1; # start with TOC-eating
my %faq;
my @toc;

my $q=0;
my $sec = 0;
my $blank=0;

while(<STDIN>) {
    if($state == 1) {
        if($_ =~ /^===========/) {
            # output the TOC with links to question-anchors
            $state = 3;
            
            my $s=0;
            my $o=0;
            for(@toc) {
                $s = $_;
                $s =~ s/^([0-9]+).*/$1/g;
                if($s != $o) {
                    my $ti = $section[$s];
                    chomp $ti;
                    $ti =~ s/^ *(.*) */$1/;
                    subtitle($ti);
                    print "\n<p>\n";
                    $o = $s;
                }
                printf "<a href=\"#%s\">%s</a> %s<br>\n",
                $link{$_}, $_, $faq{$_};
            }

            print "<hr>\n";
            
            next;
        }
        if($_ =~ /([0-9.]+\.[0-9]+) (.*)/) {
            my ($num, $phrase)=($1, $2);
    #        print STDERR "$num $phrase\n";
            $faq{$num} = $phrase;
            $faq{$num} =~ s/&/&amp;/g;
            $faq{$num} =~ s/\</&lt;/g;
            $faq{$num} =~ s/\>/&gt;/g;
            my $l = substr($phrase, 0, 32);
            # filter off "odd" chars
            $l =~ s/[^a-z0-9A-Z]/_/g;
            # filter off trailing underscores
            $l =~ s/_+\z//;
            # filter off initial underscores
            $l =~ s/^_+//;
            # filter off multiple underscores
            $l =~ s/_+/_/g;
            $link{$num} = $l;
            push @toc, $num;
        }
        elsif($_ =~ /([0-9]+)\. (.*)/) {
    #        print STDERR "SECTION: $1 \"$2\"\n";
            $section[$1]=$2;
            push @secs, $2;
        }
    }
    elsif($state == 3) {
        my $l = $_;

    #    print STDERR "C: $toc[$q]\n";

        if($secs[$sec] && ($_ =~ /^\s*([0-9]+)\. $secs[$sec]/i)) {
            # a new section
            my $ti = $l;
            chomp $ti;
            $ti =~ s/^ *(.*) */$1/;
            subtitle($ti);

            $sec++;
        }

        elsif($toc[$q] && ($_ =~ /^ *$toc[$q]/i)) {
            # a question
            my $s=$_;
            chomp $s;
            $s =~ s/&/&amp;/g;
            $s =~ s/\</&lt;/g;
            $s =~ s/\>/&gt;/g;
            $s =~ s/^ *(.*) */$1/;
            print "<a name=\"$link{$toc[$q]}\"></a>";
            print "<h3>$s</h3>\n";
            $line=0;
            $q++;
        }
        else {
            s/&/&amp;/g;
            s/\</&lt;/g;
            s/\>/&gt;/g;
            s/\#include/\&#35;include/g;
            s/\#undef/\&#35;undef/g;
            s/\#ifdef/\&#35;ifdef/g;
            s/\#ifndef/\&#35;ifndef/g;
            s/\#if/\&#35;if/g;
            s/\#else/\&#35;else/g;
            s/\#endif/\&#35;endif/g;
            s/\/\*/\/\&#42;/g;
            s/\*\//\&#42;\//g;
            # Emphasize _underlined_ words
            s/\b_([[:alnum:]]+)_\b/<em>$1<\/em>/g;

            # linkify URLs
            s/((http|https|ftp):\/\/([\w.\/%-?]*[a-z0-9\/]))/<a href=\"$2:\/\/$3\">$1<\/a>/ig;
            if($_ =~ /^     /) {
                # five or more initial spaces, use <pre>

                # remove multiple whitespaces
                $_ =~ s/[ \t]+/ /g;
                push @pre, $_;
            }
            else {
                if($pre[0]) {
                    print "<pre>\n";
                    print @pre;
                    print "</pre>\n";
                    undef @pre;
                }
                
                # prevent many blanks
                my $show = $_;
                my $pref=0;
                if($show =~ /^ *$/) {
                    $blank++;
                    $line=0;
                }
                else {
                    $blank=0;
                    if($show =~ /^([ |\t]+)/) {
                        $pref=length($1);
                    }
                    $line++;
                }
                if($oldpref == $pref) {
                    print " $show " if($blank < 2);                    
                }
                elsif($line) {
                    print "<p>$show";
                }
                $oldpref = $pref;
            }
        }
    }
}
if($pre[0]) {
    print "<pre>\n";
    print @pre;
    print "</pre>\n";
    undef @pre;
}
