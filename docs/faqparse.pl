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
                $s =~ s/^([0-9]).*/$1/g;
                if($s != $o) {
                    subtitle(sprintf "%s", $section[$s]);
                    print "\n<p>\n";
                    $o = $s;
                }
                printf "<a href=\"faq.html#%s\">%s</a> %s<br>\n", $_, $_, $faq{$_};
            }

            print "<hr>\n";
            
            next;
        }
        if($_ =~ /([0-9.]+\.[0-9]+) (.*)/) {
            my ($num, $phrase)=($1, $2);
#            print "$num $phrase\n";
            $faq{$num} = $phrase;
            push @toc, $num;
        }
        elsif($_ =~ /([0-9])\. (.*)/) {
#            print "SECTION: $1 \"$2\"\n";
            $section[$1]=$2;
            push @secs, $2;
        }
    }
    elsif($state == 3) {
        my $l = $_;

        if($secs[$sec] && ($_ =~ /^\s*[0-9]\. $secs[$sec]/i)) {
            # a new section
            subtitle($l);
            $sec++;
        }

        elsif($toc[$q] && ($_ =~ /^\s*$toc[$q]/i)) {
            # a question
            my $s=$_;
            chomp $s;
            $s =~ s/^ *(.*) */$1/;
            print "<a name=\"$toc[$q]\"></a><h3>$s</h3><p>\n";
            $q++;
        }
        else {
            my $l = $_;
            $l = s/\</&lt;/g;
            $l = s/\</&gt;/g;

            if($_ =~ /^     /) {
                # five or more initial spaces, use <pre>
                push @pre, $_;
            }
            else {
                if($pre[0]) {
                    print "<pre>\n";
                    print @pre;
                    print "</pre>\n";
                    undef @pre;
                }
                $l = s/((http|ftp):\/\/([a-z0-9.\/_%-?]*[a-z\/]))/<a href=\"$2:\/\/$3\">$1<\/a>/g;
                
                # prevent many blanks
                my $show = $_;
                if($show =~ /^ *$/) {
                    $blank++;
                }
                else {
                    $blank=0;
                }
                print "$show<br>" if($blank < 2);
            }
        }
    }
}
