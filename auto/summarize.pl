#!/usr/bin/env perl

require "CGI.pm";
require "../curl.pm";

opendir(DIR, "inbox");
my @logs = grep { /^inbox/ } readdir(DIR);
closedir(DIR);


my %combo;
my $buildnum;

my $showntop=0;
my $prevtable = -1;
my $tablesperpage = 7;

for ( 0 .. 3 ) {
    open(CLEAR, ">table$_.t");
    close(CLEAR);
}

sub tabletop {
    my @res;
    my ($date)=@_;

    $tablecount++;
    $tablenum = int($tablecount/$tablesperpage);
    my $file = "table${tablenum}.t";

    open(TABLE, ">>$file");

    if($tablenum != $prevtable) {
        my $max = scalar(@logs);
        if($max > $tablesperpage) {
            print TABLE "<p>Page: ";
            for(0 .. $max/$tablesperpage) {
                my $num = $_+1;
                my $tab = $_;
                if($tab == $tablenum) {
                    print TABLE "<b>[$num]</b> ";
                }
                else {
                    print TABLE "[<a href=\"table$tab.html\">$num</a>] ";
                }
            }
        }
    }

    if($date =~ /^(\d\d\d\d)(\d\d)(\d\d)/) {
        ($year, $month, $day) = ($1, $2, $3);
    }

    $prevtable = $tablenum;
    if(!$showntop) {
        print TABLE stitle("$year-$month-$day");
        print TABLE join("",
                   "<table cellspacing=\"0\" class=\"compile\" width=\"100%\"><tr>",
        "<th>Time</th>",
        "<th>Test</th>",
        "<th>Warn</th>",
        "<th>Options</th>",
        "<th>Description</th>",
        "<th>Name</th>",
        "</tr>\n");
        $showntop=1;
    }
    return @res;
}

sub tablebot() {
    print TABLE "</table>\n";
    $showntop=0;
    close(TABLE);
}

sub summary {
    open(SUM, ">summary.t");


    printf SUM "<p>%d builds during %d days provided by %d persons with %d different machine descriptions\n",
    $buildnum, scalar(@logs), scalar(keys %who), scalar(keys %desc);

    printf SUM "<p> The average build gave %d warnings and run %d tests. %d builds (%d%%) built warning-free.\n",
    $totalwarn/$buildnum, $totalfine/($buildnum-$totallink),
    $warnfree, $warnfree*100/$buildnum;

    printf SUM "<p> %d builds failed to link and %d builds failed one or more tests",
    $totallink, $totalfail;

    printf SUM "<p><table><tr valign=\"top\"><td nowrap><b>%d used option combos</b><br>\n", scalar(keys %combo);
    for(sort {$combo{$b} <=> $combo{$a}} keys %combo) {
        printf SUM "<span class=\"mini\">%s</span> %d times<br>\n", $_, $combo{$_};
    }
    printf SUM "<td><td nowrap><b>%d used OSes</b><br>\n", scalar(keys %oses);
    for(sort {$oses{$b} <=> $oses{$a}} keys %oses) {
        printf SUM "<span class=\"mini\">%s</span> %d times<br>\n", $_, $oses{$_};
    }

    print SUM "</td></tr></table>\n";
    close(SUM);
}


my @data;

if(!@logs) {
    print TABLE "No build logs available at this time";
}
else {
    @data = "";
    for(reverse sort @logs) {
        my $filename=$_;
        singlefile("inbox/$filename");
    }
    summary();

    my $prevdate;
    if(@data) {
        my $i;
        for(reverse sort @data) {
            my ($lyear, $lmonth, $lday);
            my $l = $_;
            my $class= $i&1?"even":"odd";
            if(s/<tr>/<tr class=\"$class\">/) {
                $i++;
            }
            if($l =~ /\<\!-- (\d\d\d\d)(\d\d)(\d\d)/) {
                ($lyear, $lmonth, $lday) = ($1, $2, $3);
            }
            else {
                last;
            }
            
            if("$lyear$lmonth$lday" ne $prevdate) {
                if($prevdate) {
                    tablebot();
                }
                tabletop("$lyear$lmonth$lday");
            }
            
            $prevdate ="$lyear$lmonth$lday";
            

            print TABLE $_;
        }
        tablebot();
    }

}

exit;

my $warning=0;

sub endofsingle {
    my $escname = CGI::escape($name);
    my $escdate = CGI::escape($date);

    my $libver;
    my $sslver;
    my $zlibver;
    my $ipv6="-";
    my $krb4="-";
    my $zlib="-";
    my $gss="-";

    if($libcurl =~ /libcurl\/([^ ]*)/) {
        $libver = $1;
    }
    if($libcurl =~ /OpenSSL\/([^ ]*)/i) {
        $sslver = $1;
    }
    if($libcurl =~ /zlib\/([^ ]*)/i) {
        $zlibver = $1;
        $zlib = "Z";
    }
    if($libcurl =~ /krb4/) {
        $krb4 = "K";
    }
    if($ipv6enabled) {
        $ipv6 = "6";
    }
    if($gssapi) {
        $gss = "G";
    }

    $showdate = $date;
   # $showdate =~ s/2003//g;
   # $showdate =~ s/(GMT|UTC|Mon|Tue|Wed|Thu|Fri|Sat|Sun)//ig;
    $showdate =~ s/.*(\d\d):(\d\d):(\d\d).*/$1:$2/;

    # prefer the date from the actual log file, it might have been from
    # another day
    $logdate=`date --utc --date "$date" "+%Y-%m-%d"`;
    if($logdate =~ /^(\d\d\d\d)-(\d\d)-(\d\d)/) {
        ($lyear, $lmonth, $lday) = ($1, $2, $3);
    }
    else {
        ($lyear, $lmonth, $lday) = ($year, $month, $day);
    }

    my $res = join("",
                   "<!-- $lyear$lmonth$lday $showdate --><tr>\n",
                   "<td>$showdate</td>\n");
    my $a;
    if($buildid =~ /^(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)-(\d+)/) {
        my ($byear, $bmon, $bday, $bhour, $bmin, $bsec, $bpid)=
            ($1, $2, $3, $4, $5, $6, $7);
        $a = "<a href=\"log.cgi?id=$buildid\">";
    }
    else {
        $a = "<a href=\"./showlog.cgi?year=$year&month=$month&day=$day&name=$escname&date=$escdate\">";
    }

    if($fail || !$linkfine || !$fine) {
        $res .= "<td class=\"buildfail\">$a";
        if(!$linkfine) {
            if($cvsfail) {
                $res .= "CVS";
            }
            elsif(!$configure) {
                $res .= "build env";
            }
            else {
                $totallink++;
                $res .= "link";
            }
        }
        elsif($fail) {
            $res .= $failamount;
            $totalfail++;
        }
        else {
            $res .= "fail";
        }
        $res .= "</a></td>\n";
    }
    else {
        $totalfine += $fine;
        $res .= "<td class=\"buildfine\">$a $fine";

        if($skipped) {
            #$res .= "+$skipped";
        }
        $res .= "</a></td>\n";
    }

    $totalwarn += $warning;
    if($warning>0) {
        $res .= "<td class=\"buildfail\">$warning</td>";
    }
    else {
        $warnfree++;
        $res .= "<td>0</td>\n";
    }

    $memory=($memorydebug)?"D":"-";
    $https=($httpstest)?"S":"-";
    $a=$ares?"A":"-";

    my $uniq = $uname.$libver.$sslver.$krb4.$ipv6.$memory.$https;

    my $o = "$krb4$ipv6$memory$https$a$zlib$gss";

    $res .= "<td class=\"mini\">$o</td>\n<td>$desc</td>\n<td>$name</td></tr>\n";

    $combo{$o}++;
    $desc{$desc}++;
    $who{$name}++;
    if($os) {
        $oses{$os}++;
    }

    $buildnum++;

    $fail=$name=$email=$desc=$date=$libcurl=$uname="";
    $fine=0;
    $linkfine=0;
    $warning=0;
    $skipped=0;
    $configure=0;
    $memorydebug=0;
    $httpstest=0;
    $cvsfail=0;
    $ares=0;
    $buildid="";
    $failamount=0;
    $ipv6enabled=0;
    $gssapi=0;
    $os="";

    return $res;
}

my $state =0;
sub singlefile {
    my ($file) = @_;

    if($file =~ /.*(\d\d\d\d)-(\d\d)-(\d\d)/) {
        ($year, $month, $day) = ($1, $2, $3);
    }

    chmod 0644, $file;

    open(READ, "<$file");
    while(<READ>) {
        chomp;
        my $line = $_;

 #       print "L: $state - $line\n";
        if($_ =~ /^INPIPE: startsingle here ([0-9-]*)/) {
            $buildid = $1;
        }
        # we don't check for state here to allow this to abort all
        # states
        elsif($_ =~ /^testcurl: STARTING HERE/) {
            # mail headers here
            if($state) {
                push @data, endofsingle();
            }
            $state = 2;
        }
        elsif((2 == $state)) {
            # this is testcurl output
            if($_ =~ /^testcurl: ENDING HERE/) {
                # mail headers here
                push @data, endofsingle();
                $state = 0;
            }
            elsif($_ =~ /^testcurl: NAME = (.*)/) {
                $name = $1;
            }
            elsif($_ =~ /^testcurl: EMAIL = (.*)/) {
                $email = $1;
            }
            elsif($_ =~ /^testcurl: DESC = (.*)/) {
                $desc = $1;
            }
            elsif($_ =~ /^testcurl: date = (.*)/) {
                $date = $1;
            }
            elsif($_ =~ /^TESTFAIL: These test cases failed: (.*)/) {
                $fail = $1;
            }
            elsif($_ =~ /^TESTDONE: (\d*) tests out of (\d*)/) {
                $fine = $1;
                $failamount = ($2 - $1);
            }
            elsif($_ =~ /^TESTINFO: (\d*) tests were skipped/) {
                $skipped = $1;
            }
            elsif($_ =~ /^\* (libcurl\/.*)/) {
                $libcurl = $1;
            }
            elsif(($_ =~ /([.\/a-zA-Z0-9]*)\.[chy]:([0-9:]*): /) ||
                  ($_ =~ /\"([_.\/a-zA-Z0-9]+)\", line/) ||
                  ($_ =~ /^cc: Warning: ([.\/a-zA-Z0-9]*)/) ||
                  ($_ =~ /cc: (REMARK|WARNING) File/) ||
                  ($_ =~ /: (remark|warning) \#/) ||
                  # MIPS o32 compiler:
                  ($_ =~ /^cfe: Warning (\d*):/) ||
                  # MSVC
                  ($_ =~ /^[\.\\]*([.\\\/a-zA-Z0-9-]*)\.[chy]\(([0-9:]*)/)
                  ) {
                # first one, gcc
                # second one, xlc (on AIX)
                # third one, cc on Tru64
                # forth one, MIPSPro C 7.3 on IRIX
                # fifth one, icc 8.0 Intel compiler on Linux
                $warning++;
            }
            elsif($_ =~ /^testcurl: failed to update from CVS/) {
                $cvsfail=1;
            }
            elsif($_ =~ /^testcurl: configure created/) {
                $configure=1;
            }
            elsif($_ =~ /^testcurl: src\/curl was created fine/) {
                $linkfine=1;
            }
            elsif($_ =~ /^\* libcurl debug: *(.*)/) {
                if($1 eq "ON") {
                    $memorydebug=1;
                }
                else {
                    $memorydebug=0;
                }
            }
            elsif($_ =~ /^\* System: *(.*)/) {
                $uname = $1;
            }
            elsif($_ =~ /^\* libcurl SSL: *(.*)/) {
                if($1 eq "ON") {
                    $httpstest=1;
                }
                else {
                    $httpstest=0;
                }
            }
            elsif($_ =~ /^\#define USE_ARES 1/) {
                $ares = 1;
            }
            elsif($_ =~ /^\#define ENABLE_IPV6 1/) {
                $ipv6enabled = 1;
            }
            elsif($_ =~ /^\#define HAVE_GSSAPI 1/) {
                $gssapi=1;
            }
            elsif($_ =~ /^\#define OS \"([^\"]*)\"/) {
                $os=$1;
            }

        }
    }
    if($state) {
        # only for error-cases
        push @data, endofsingle();
    }
    close(READ);
}
