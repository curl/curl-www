#!/usr/bin/env perl

require "CGI.pm";
require "../curl.pm";

opendir(DIR, "inbox");
my @logs = grep { /^inbox/ } readdir(DIR);
closedir(DIR);

cat("head.html");

my $showntop=0;
sub tabletop {
    my @res;
    my ($date)=@_;

    if($date =~ /^(\d\d\d\d)(\d\d)(\d\d)/) {
        ($year, $month, $day) = ($1, $2, $3);
    }

    if(!$showntop) {
        title("$year-$month-$day");
        print join("",
                         "<table cellspacing=\"0\" class=\"compile\" width=\"100%\"><tr>",
        "<th>time</th>",
        "<th>test</th>",
        "<th>warn</th>",
        "<th>ssl</th>",
        "<th>zlib</th>",
        "<th>krb4</th>",
        "<th>ipv6</th>",
        "<th>mem</th>",
        "<th>https</th>",
        "<th>asynch</th>",
        "<th>desc</th>",
        "<th>who</th>",
        "</tr>\n");
        $showntop=1;
    }
    return @res;
}

sub tablebot() {
    print "</table>\n";
    $showntop=0;
}

my @data;

if(!@logs) {
    print "No build logs available at this time";
}
else {
    @data = "";
    for(reverse sort @logs) {
        my $filename=$_;

        singlefile("inbox/$filename");

    }
    my $prevdate;
    if(@data) {
        my $i;
        for(reverse sort @data) {
            my $lyear, $lmonth, $lday;
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
            

            print $_;
        }
        tablebot();
    }

}
cat("foot.html");

exit;

sub cat {
    my ($file)=@_;
    open(FILE, "<$file");
    while(<FILE>) {
        print $_;
    }
    close(FILE);
}

my $warning=0;

sub endofsingle {
    my $escname = CGI::escape($name);
    my $escdate = CGI::escape($date);

    my $libver;
    my $sslver;
    my $zlibver;
    my $ipv6;
    my $krb4;

    if($libcurl =~ /libcurl\/([^ ]*)/) {
        $libver = $1;
    }
    if($libcurl =~ /OpenSSL\/([^ ]*)/i) {
        $sslver = $1;
    }
    if($libcurl =~ /zlib\/([^ ]*)/i) {
        $zlibver = $1;
    }
    if($libcurl =~ /krb4/) {
        $krb4 = "ON";
    }
    if($libcurl =~ /ipv6/) {
        $ipv6 = "ON";
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
                $res .= "link";
            }
        }
        elsif($fail) {
            my @errors = split(" ", $fail);
            if(scalar(@errors) < 5) {
                $res .= "$fail";
            }
            else {
                $res .= join(" ", $errors[0], $errors[1], $errors[2],
                             $errors[3], "and more");
            }
        }
        else {
            $res .= "fail";
        }
        $res .= "</a></td>\n";
    }
    else {
        $res .= "<td class=\"buildfine\">$a $fine";

        if($skipped) {
            $res .= "+$skipped";
        }
        $res .= "</a></td>\n";
    }

    if($warning>0) {
        $res .= "<td class=\"buildfail\">$warning</td>";
    }
    else {
        $res .= "<td>0</td>\n";
    }

    $memory=($memorydebug)?"ON":"&nbsp;";
    $https=($httpstest)?"ON":"&nbsp;";
    $a=$ares?"ON":"&nbsp";

    my $uniq = $uname.$libver.$sslver.$krb4.$ipv6.$memory.$https;

    $res .= join("", 
                 "<td>$sslver</td>\n",
                 "<td>$zlibver</td>\n",
                 "<td>$krb4</td>\n",
                 "<td>$ipv6</td>\n",
                 "<td>$memory</td>\n",
                 "<td>$https</td>\n",
                 "<td>$a</td>\n");

    $res .= "<td>$desc</td>\n<td>$name</td>\n";
    $res .= "</tr>\n";

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
            }
            elsif($_ =~ /^TESTINFO: (\d*) tests were skipped/) {
                $skipped = $1;
            }
            elsif($_ =~ /^\* (libcurl\/.*)/) {
                $libcurl = $1;
            }
            elsif(($_ =~ /([.\/a-zA-Z0-9]*)\.[ch]:([0-9:]*): /) ||
                  ($_ =~ /\"([_.\/a-zA-Z0-9]+)\", line/) ||
                  ($_ =~ /^cc: Warning: ([.\/a-zA-Z0-9]*)/) ||
                  ($_ =~ /cc: WARNING File/)
                  ) {
                # first one, gcc
                # second one, xlc (on AIX)
                # third one, cc on Tru64
                # forth one, MIPSPro C 7.3 on IRIX
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

        }
    }
    if($state) {
        # only for error-cases
        push @data, endofsingle();
    }
    close(READ);
}
