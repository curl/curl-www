#!/usr/bin/perl

require "../latest.pm";
require "./stuff.pm";

# Number of recent versions to check
my $lastfew = 7;

my $show = $ARGV[0];

# get database
$db=new pbase;
$db->open($databasefilename);

my $mod; # number of changes made

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    gmtime(time);
my $logfile = sprintf("log/remcheck-%04d%02d%02d-%02d%02d%02d.html",
                      $year+1900, $mon+1, $mday, $hour, $min, $sec);

# open and close each time to allow removal at any time
sub logmsg {
    open(FTPLOG, ">>$logfile");
    for(@_) {
        print FTPLOG "$_<br>";
    }
    close(FTPLOG);
    print @_;
}

sub timestamp {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
        gmtime(time);
    return  sprintf("%04d%02d%02d-%02d%02d%02d",
                    $year+1900, $mon+1, $mday, $hour, $min, $sec);
}

&latest::scanstatus($latest::dldir);

@all = $db->find_all("typ"=>"^entry\$");

open(FTPLOG, ">>$logfile");
print FTPLOG getheader("Remcheck $logfile");
close(FTPLOG);

logmsg "\$version = $latest::headver\n";
logmsg sprintf("%d packages found in database\n", scalar(@all));
logmsg "All times in this log is GMT/UTC\n";
logmsg "curl version used in this script:\n";
logmsg `curl --version`;
my $version = $latest::headver;

if($show) {
    logmsg "<strong>told to only deal with packages matching \"$show\"</strong>\n";
}

sub show {
    my ($t)=@_;
    if($t eq "-") {
        return "";
    }
    return $t;
}

sub content_length {
    my (@doc)=@_;
    my $cl;
    my $stat=0;

    if(join("", @doc) =~ /Content-Length: *(\d+)/i) {
        $cl = $1;
        $stat = 1;
        logmsg " Content-Length: $cl found\n";

        if(join("", @doc) =~ /Content-Type: *text\//i) {
            # This is probably an index page, not a downloadable binary,
            # so the length is meaningless
            $cl = '';
            logmsg " but ignored\n";
        }
    }
    elsif((join("", @doc) =~ /^HTTP\/\d.\d (\d+)/)  && ($1 == 200)) {
        # still, it return 200 which indicates OK!
        logmsg " No Content-Length but 200 response-code!\n";
        $stat = 1;
    }

    return ($cl, $stat);
}

sub getlastfewversions {
    my @few;
    my $per;
    for $per ($db->find_all()) {
        my $val=$$per{'curl'};
        $hash{$val}=1;
    }

    sub numit {
        my ($str)=@_;
        my @p=split(/\./, $str);

        return $p[0]*10000 + $p[1]*100 + $p[2];
    }

    sub sortit {
        return numit($a) <=> numit($b);
    }

    my $c;
    for(reverse sort sortit keys %hash) {
        push @few, $_;
        if($c++ >= $lastfew) {
            last;
        }
    }
    return @few;
}

sub islastfewversions {
    my ($ver)=@_;

    my @few = getlastfewversions();

    for(@few) {
        if($_ eq $ver) {
            # yeps
            return 1;
        }
    }
    # nopes
    return 0;
}

# Clean up the error code description from the man page
sub cleanerrdesc {
    my ($desc, $alt) = @_;
    chomp($desc);
    $desc = $alt if not $desc;  # don't cut off at period if none there
    $desc =~ s/-$//;   # remove trailing dash
    $desc =~ s/  / /g; # remove duplicate spaces
    $desc .= "...." if ($desc && substr($desc, -1) ne ".");  # ellipses if no period
    $desc =~ s/\.$//;   # finally, remove the trailing dot
    return $desc;
}

my %curlerrors;
# Return a description for a curl error code
sub curlerror {
    my $err = $_[0];
    if(%curlerrors) {
        return $curlerrors{$err};
    }
    # Read all the curl error codes from the manual
    open(my $fh, "-|", "curl --manual");
    while(<$fh>) {
        last if(/^EXIT CODES$/);
    }
    my $awaitdesc;
    while(<$fh>) {
        if(/^\s*$/) {
            next;  # ignore blank lines
        } elsif($awaitdesc) {
            # New style, with description on a following line after the error #
            my $desc = cleanerrdesc($_, $_);
            $curlerrors{$awaitdesc} = $desc;
            $awaitdesc = '';
        } elsif(/^\s{1,12}(\d+)\s*(.*\.)?\s*(.*)\s*$/) {
            # Old style, description on the same line as the error #
            my $num = $1;
            my $desc = cleanerrdesc($2, $3);
            if($desc) {
                $curlerrors{$num} = $desc;
            } else {
                # description will come on the next line
                $awaitdesc = $num;
            }
        } elsif (/^[A-Z]/) {
            # In the next manual section
            last;
        }
    }
    close($fh);

    return $curlerrors{$err};
}

# a hash with arrays (url => url contents)
my %urlhash;
sub geturl {
    my ($url, $head) = @_;
    my $curlcmd="curl -Lfsm120 --retry 2 --retry-delay 5 --max-redirs 5 --cookie \"\" -A \"Mozilla/curl.se dl-package-check-probe\" --ftp-method singlecwd --ssl";

    if(!$head) {
        my $t = time();

        # six weeks ago
        $t -= (24*3600)*7*6;

        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
            gmtime($t);
        my $weeksago = sprintf("%04d%02d%02d %02d:%02d:%02d",
                                  $year+1900, $mon+1, $mday,
                                  $hour, $min, $sec);

        #$curlcmd .= " -z \"$weeksago\"";
        $curlcmd .= " --compressed";
    }

    if($head) {
        # we do not cache HEAD requests
        $curlcmd .= " --head";
        #logmsg " issue a HEAD request\n";
    }
    elsif($urlhash{$url}) {
        # return the array
        logmsg " URL contents CACHED, no need to fetch again\n";
        return @{$urlhash{$url}};
    }
    logmsg " \$ $curlcmd \"<a href=\"" . CGI::escapeHTML($url) . "\">" .
           CGI::escapeHTML($url) . "</a>\"\n";
    my @content = `$curlcmd \"$url\"`;
    if($?) {
        logmsg " Failed with error " . ($? >> 8) . " (" . CGI::escapeHTML(curlerror($? >> 8)) . ")\n";
        @content = ();
    }
    if($head) {
        # Strip header blocks due to redirects, leaving only the final one
        while($content[0] =~ /^HTTP\/\d.\d 3\d+/) {
            while((shift @content) !~ /^[\x0A\x0D]*$/ ) {}
        }
    } else {
        # we do not cache HEAD requests
        if(@content) {
            # store the content in the hash
            @{$urlhash{$url}}=@content;
        }
    }
    return @content;
}

my $regexmisses=0;
my $update=0;
my $uptodate=0;
my $missing=0;
my $failedcheck=0;
my $localpackage=0;
my $oldies=0;
my $ref;
for $ref (@all) {
    my $inurl = $$ref{'churl'};
    my $chregex = $$ref{'chregex'};
    my $churl = $inurl;
    my $osversion = lc($$ref{'osver'});
    my $cpu = lc($$ref{'cpu'});

    # is '$version' embedded in the test URL
    my $versionembedded;

    my $s = $$ref{'os'};

    if($s eq "-") {
        $s = "Generic";
    }
    my $desc = sprintf("%s %s %s %s %s %s by %s (%s)",
                       $s,
                       show($$ref{'osver'}),
                       show($$ref{'cpu'}),
                       show($$ref{'flav'}),
                       show($$ref{'pack'}),
                       show($$ref{'type'}),
                       $$ref{'name'},
                       $$ref{'curl'});

    if($show && ($desc !~ /$show/i)) {
        next;
    }

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
        gmtime(time);
    my $t = sprintf ("%02d:%02d:%02d", $hour, $min, $sec);

    logmsg sprintf "<h2>$t $desc <a href=\"https://curl.se/dl/mod_entry.cgi?__id=%s\">edit</a></h2>", $$ref{'__id'};

    if($$ref{'hide'} eq "Yes") {
        logmsg "Marked as hidden, skipping the check\n";
        $hidden++;
    }

    elsif($$ref{'curl'} eq $version) {
        logmsg " Already at latest version ($version), no need to check\n";
        $uptodate++;
    }
    elsif($$ref{'file'} !~ /^(http|https|ftp|ftps):/) {
        logmsg " Local package, no check needed\n";
        $localpackage++;
    }
    elsif($churl && ($churl ne "-")) {
        # there is a URL to check

        if(!islastfewversions($$ref{'curl'})) {

            # the database version of this is older than the last few
            # versions, slow down the checking of this by aborting this
            # package check in a random matter

            my $r = rand(100);
            # 20% continue rate. This gives a 79% chance that it will be
            # checked at least every week (when run once a day), and a 99.9%
            # chance that it will be checked at least once every month.
            my $skip = ($r > 20);
            logmsg sprintf(" Not a recent version, %s\n",
                           $skip?"SKIP":"but check anyway");
            if($skip) {
                $oldies++;
                next;
            }
        }

        # first unescape HTML encoding
        $churl = CGI::unescapeHTML($churl);

        logmsg sprintf(" Check URL: %s\n", CGI::escapeHTML($churl));

        # expand $version!
        if($churl =~ s/\$version/$version/g) {
            # 'fixedver' means that we have the version number in the URL
            # and thus success means this version exists
            $versionembedded=1;
        }
        $churl =~ s/\$osversion/$osversion/g;
        $churl =~ s/\$cpu/$cpu/g;

        my @data;

        if($chregex) {
            @data = geturl($churl, 0);
            if(!$data[0]) {
                logmsg " <div class=\"buildfail\">$churl failed. Document too old, missing or URL/host dead for now</div>\n";
                $failedcheck++;
                next;
            }

            $$ref{'remcheck'} = timestamp();

            # there is a regex to check for in the downloaded page
            $chregex = CGI::unescapeHTML($chregex);

            logmsg sprintf(" Check regex <b><tt>%s</tt></b>\n",
                           CGI::escapeHTML($chregex));

            # replace variables in the regex too
            $chregex =~ s/\$version/$version/g;
            $chregex =~ s/\$osversion/$osversion/g;
            $chregex =~ s/\$cpu/$cpu/g;

            logmsg sprintf(" Use regex <b><tt>%s</tt></b>\n",
                           CGI::escapeHTML($chregex));
            #$chregex = quotemeta($chregex);
            my $l;
            my $match;
            for $l (@data) {
              #  print "$l\n";
                if($l =~ /$chregex/) {
                    my $r = $1;
                    if($versionembedded) {
                        # '$version' was part of the URL and thus we do not
                        # need/want to extract it from the regex match
                        $r = $version;
                    }
                    $match++;
                    logmsg " Remote version: <b>$r</b>\n";

                    if($$ref{'curl'} ne $r) {
                        # TODO: actually store the new version here
                        $update++;
                        logmsg " <div class=\"latest2\">NEWER version found!</div>\n";
                        $$ref{'remdate'} = timestamp();
                        $$ref{'curl'}=$r;
                        if($versionembedded) {
                            # the version string is embedded in the test URL
                            # so we update the download URL as well!
                            $$ref{'file'}=$churl;
                            logmsg " Updated download URL!\n";
                        }
                        $$ref{'size'}='';
                    }
                    else {
                        $uptodate++;
                    }
                    last;
                }
            }
            if(!$match) {
                $regexmisses++;
                logmsg "<div class=\"buildfail\">NO line matched the regex!</div>\n";
            }
        }
        else {
            # since there is no regex, just do a head request to verify the
            # file's mere existence
            @data = geturl($churl, 1);

            # store version as of now
            my $ver = $version;
            my ($cl, $st);

            ($cl, $st) = content_length(@data);
            my $lasttried = 1;

            if(!$st && $versionembedded) {
                #
                # Only scan for older URLs if the $version is part of it
                #

                my @few = getlastfewversions();
                @few = grep (!/^$version$/, @few); # we already tried the latest

                # while no data was received, try older versions
                while(@few && !$st) {

                    if($ver eq $$ref{'curl'}) {
                        # no need to scan for older packages than what
                        # we already have
                        last;
                    }

                    $ver = shift @few;
                    $churl = $inurl;
                    $churl =~ s/\$version/$ver/g;
                    $churl =~ s/\$osversion/$osversion/g;
                    $churl =~ s/\$cpu/$cpu/g;

                    @data = geturl($churl, 1);
                    ($cl, $st) = content_length(@data);
                    $lasttried++;
                }
            }

            if(!$st) {
                logmsg " <div class=\"buildfail\">None of the $lasttried latest versions found!</div>\n";
                $failedcheck++;
                next;
            }

            $$ref{'remcheck'} = timestamp();

            logmsg " Remote version: <b>$ver</b>\n";

            if($versionembedded) {
                # the version string is embedded in the test URL
                # so we update the download URL as well!
                $$ref{'file'}=$churl;
            }
            # store the size, whether it is known or unknown (blank)
            $$ref{'size'}=$cl;
            logmsg " Store size: " . ($cl || "unknown") . " bytes\n";

            if($$ref{'curl'} ne $ver) {
                # TODO: actually store the new version here
                $update++;
                logmsg " <div class=\"latest2\">NEWER version found!</div>\n";
                $$ref{'remdate'} = timestamp();
                $$ref{'curl'} = $ver;
            }
            else {
                $uptodate++;
            }
        }
    }
    else {
        logmsg " Package lacks autocheck URL\n";
        $missing++;
    }
    $db->save();
}

logmsg "<h1>Summary</h1>\n";
logmsg "$uptodate remote packages found up-to-date with database versions\n";
logmsg "<div class=\"buildfail\">$failedcheck packages failed to get checked</div>\n";
logmsg "$localpackage packages are local and taken care of differently\n";
logmsg "$oldies checks were skipped due to old release number\n";
logmsg "<div class=\"buildfail\">$regexmisses regexes did not match on successful URL fetches</div>\n";
logmsg "$hidden packages were skipped since they are 'hidden'\n";

if($missing) {
    logmsg "$missing listed packages lacked autocheck URL\n";
}

# one or more updated entries, save!
# we have updated time stamps after each run, always save!
$db->save();

logmsg "<div class=\"latest2\">$update package versions updated</div>\n";
