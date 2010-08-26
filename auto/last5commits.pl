#!/usr/bin/perl
#
# Copyright (C) 2010, Daniel Stenberg, <daniel@haxx.se>

#
# commit d4cd5411a66d6814adccdfc81ff1d8a80e8c58af
# Author: Daniel Stenberg <daniel@haxx.se>
# Date:   Mon Mar 22 22:00:55 2010 +0100
#
#     Thomas Lopatic fixed the alarm()-based DNS timeout
#
# :100644 100644 02d7b27... 8d81272... M  CHANGES
# :100644 100644 29ad85b... 072ad7e... M  RELEASE-NOTES
#
my @lines=`cd curl && git log --raw -20`;

sub header {
    print "<table>\n";
}

sub footer {
    print "</table>\n";
}

sub showc {
    $cl = $counter++&1?"odd":"even";
    if($c{'commit'}) {
        my $auth = $c{'Author:'};
        my $desc = $c{'desc'};
        my $date = $c{'Date:'};

        $auth =~ s/<.*//g;

        $desc =~ s/&/&amp;/g;
        $desc =~ s/\</&lt;/g;
        $desc =~ s/\>/&gt;/g;
        $desc =~ s/   */<p>/g;

        printf("<tr class=\"$cl\"><td colspan=\"2\"><b>%s</b> at <a href=\"%s/%s\">%s</a></td></tr><tr class=\"$cl\"><td>%s</td><td><pre>%s</pre></td></tr>\n",
               $auth,
               "http://github.com/bagder/curl/commit",
               $c{'commit'},
               $date,
               $desc,
               $c{'files'});
    }
    undef %c;
}

sub showlines {

    for my $l (@lines) {
        chomp $l;

        if($l =~ /^(commit|Author:|Date:) *(.*)/) {
            my ($k, $v)=($1, $2);
            if($k eq "commit") {
                showc();
            }
            $c{$k}=$v;
        }
        elsif($l =~ /^    (.*)/) {
            my $d=$1;
            $c{'desc'}.= "$d ";
        }
        elsif($l =~ /^:.*(.)\t(.*)/) {
            $c{'files'} .= "$1 $2\n";
        }
    }
    showc();

}

header();
showlines();
footer();

