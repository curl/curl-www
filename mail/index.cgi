#!/usr/local/bin/perl

require "/home/dast/perl/date.pm";

require "../curl.pm";

print "Content-Type: text/html\n\n";

&catfile("mail.html");

&title("Mailing List Archives");

print "All posts to the mailing lists are archived and can be reached from here. They're indexed monthly.";

#######################################################################
# main mailing list index
#

print "<p><table cellspacing=3 cellpadding=10 border=3><tr valign=top><td width=33%>\n";

print "<p><b>Main mailing list:</b>\n";

@dirs = `ls -1d archive-????-??`;
for(@dirs) {
    chop;
    if($_ =~ /(\d\d\d\d)-(\d\d)/) {
        $years{$1}=1;
    }
}

@syears = sort { $b <=> $a } keys %years;

for(@syears) {
    $thisyear=$_;
    my $pr=0;

    for(@dirs) {
        if($_ =~ /(\d\d\d\d)-(\d\d)/) {
            my $year=$1;
            my $mon=$2;
            
            if($thisyear == $year) {
                if(!$pr++) {
                    print "<p><b>Year $thisyear</b><br>\n";
                }
                print "<a href=\"$_/\">".&MonthNameEng($2)."</a> \n";
            }
        }
    }
}

print "<p><b>Year 1999</b><br>\n";

print " <a href=\"archive_pre_oct_99/\">August - September</a>\n",
    "<br> <a href=\"archive\">October - December</a>",
    "\n";

#######################################################################
# The libcurl index
#

print "</td><td bgcolor=\"#e0e0e0\" width=33%>\n";

print "<p><b>Libcurl mailing list:</b>\n";

@dirs = `ls -1d lib-????-??`;
for(@dirs) {
    chop;
    if($_ =~ /(\d\d\d\d)-(\d\d)/) {
        $years{$1}=1;
    }
}

@syears = sort { $b <=> $a } keys %years;

for(@syears) {
    $thisyear=$_;
    my $pr=0;

    for(@dirs) {
        if($_ =~ /(\d\d\d\d)-(\d\d)/) {
            $year=$1;
            $mon=$2;
            
            if($thisyear == $year) {
                if(!$pr++) {
                    print "<p><b>Year $thisyear</b><br>\n";
                }
                print "<a href=\"$_/\">".&MonthNameEng($2)."</a> \n";
            }
        }
    }
}
print " <a href=\"http://lists.sourceforge.net/archives//curl-library/\">February - Sepember</a>\n";

#######################################################################
# The curl-and-php index
#

print "</td><td width=33%>\n";

print "<p><b>curl-and-php mailing list:</b>\n";

@dirs = `ls -1d curlphp-????-??`;
for(@dirs) {
    chop;
    if($_ =~ /(\d\d\d\d)-(\d\d)/) {
        $years{$1}=1;
    }
}

@syears = sort { $b <=> $a } keys %years;

for(@syears) {
    $thisyear=$_;
    my $pr=0;

    for(@dirs) {
        if($_ =~ /(\d\d\d\d)-(\d\d)/) {
            $year=$1;
            $mon=$2;
            
            if($thisyear == $year) {
                if(!$pr++) {
                    print "<p><b>Year $thisyear</b><br>\n";
                }
                print "<a href=\"$_/\">".&MonthNameEng($2)."</a> \n";
            }
        }
    }
}

print "</td></tr></table>\n";

&catfile("../foot.html");

print "</body></html>\n";
