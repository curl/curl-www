#!/usr/bin/perl

require "../latest.pm";
require "stuff.pm";

# get database
$db=new pbase;
$db->open($databasefilename);

my $mod; # number of changes made

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    gmtime(time);
my $logfile = sprintf("log/remcheck-%04d%02d%02d-%02d%02d%02d.log",
                      $year+1900, $mon+1, $mday, $hour, $min, $sec);

# open and close each time to allow removal at any time
sub logmsg {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
        gmtime(time);
    open(FTPLOG, ">>$logfile");
    printf FTPLOG ("%02d:%02d:%02d ", $hour, $min, $sec);
    print FTPLOG @_;
    close(FTPLOG);
    print @_;
}

sub timestamp {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
        gmtime(time);
    return  sprintf("%04d%02d%02d-%02d%02d%02d",
                    $year+1900, $mon+1, $mday, $hour, $min, $sec);
}

&latest::scanstatus();

@all = $db->find_all("typ"=>"^entry\$");

logmsg "\$version = $latest::headver\n";
logmsg sprintf("%d packages found in database\n", scalar(@all));
logmsg "All times in this log is GMT/UTC\n";
logmsg "curl version used in this script:\n";
logmsg `curl --version`;
my $version = $latest::headver;

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

    if(join("", @doc) =~ /Content-Length: *(\d+)/i) {
        $cl = $1;
        logmsg " Content-Length: $cl found\n";
    }
    return $cl;
}

sub getlast5versions {
    my @five;
    my $per;
    for $per ($db->find_all()) {
        my $val=$$per{'curl'};
        $hash{$val}=1;
    }
    
    sub numit {
        my ($str)=@_;
        my @p=split(/\./, $str);
        
        return $p[0]*1000 + $p[1]*100 + $p[2];
    }
    
    sub sortit {
        return numit($a) <=> numit($b);
    }
    
    my $c;
    for(reverse sort sortit keys %hash) {
        push @five, $_;
        if($c++ >= 5) {
            last;
        }
    }
    return @five;
}

#print getlast5versions();

# a hash with arrays (url => url contents)
my %urlhash;
sub geturl {
    my ($url, $head) = @_;
    my $curlcmd="curl -Lfsm20";

    if(!$head) {
        my $t = time();
    
        # two weeks ago
        $t -= (24*3600)*14;

        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
            gmtime($t);
        my $twoweeksago = sprintf("%04d%02d%02d %02d:%02d:%02d",
                                  $year+1900, $mon+1, $mday,
                                  $hour, $min, $sec);

        $curlcmd .= " -z \"$twoweeksago\" --compressed";
    }

    if($head) {
        # we don't cache HEAD requests
        $curlcmd .= " --head";
        #logmsg " issue a HEAD request\n";
    }
    elsif($urlhash{$url}) {
        # return the array
        logmsg " URL contents CACHED, no need to fetch again\n";
        return @{$urlhash{$url}};
    }
    logmsg " \$ $curlcmd \"$url\"\n";
    my @content = `$curlcmd \"$url\"`;
    if(@content) {
        # store the content in the hash
        @{$urlhash{$url}}=@content;
    }
    return @content;
}

my $update=0;
my $uptodate=0;
my $missing=0;
my $failedcheck=0;
my $localpackage=0;
my $ref;
for $ref (@all) {
    my $inurl = $$ref{'churl'};
    my $chregex = $$ref{'chregex'};
    my $churl = $inurl;
    my $osversion = $$ref{'osver'};

    # is '$version' embedded in the test URL
    my $versionembedded;

    my $s = $$ref{'os'};

    if($s eq "-") {
        $s = "Generic";
    }
    logmsg sprintf("===> Package: %s %s %s %s %s by %s (%s)\n",
                   $s,
                   show($$ref{'osver'}),
                   show($$ref{'cpu'}),
                   show($$ref{'flav'}),
                   show($$ref{'pack'}),
                   $$ref{'name'},
                   $$ref{'curl'});
    logmsg sprintf " Modify: http://curl.haxx.se/dl/mod_entry.cgi?__id=%s\n",
    $$ref{'__id'};


    if($$ref{'curl'} eq $version) {
        logmsg " Already at latest version ($version), no need to check\n";
        $uptodate++;
    }
    elsif($$ref{'file'} !~ /^(http|ftp):/) {
        logmsg " Local package, no check needed\n";
        $localpackage++;
    }
    elsif($churl) {
        # there's a URL to check

        # first unescape HTML encoding
        $churl = CGI::unescapeHTML($churl);

        logmsg " Check URL: \"$churl\"\n";

        $$ref{'remcheck'} = timestamp();

        # expand $version!
        if($churl =~ s/\$version/$version/g) {
            # 'fixedver' means that we have the version number in the URL
            # and thus success means this version exists
            $versionembedded=1;
        }
        $churl =~ s/\$osversion/$osversion/g;

        logmsg " Used URL: \"$churl\"\n";
        my @data;

        if($chregex) {
            @data = geturl($churl, 0);
            if(!$data[0]) {
                logmsg " $churl failed, no such URL or dead for now\n";
                $failedcheck++;
                next;
            }

            # there's a regex to check for in the downloaded page
            $chregex = CGI::unescapeHTML($chregex);

            logmsg " Check regex \"$chregex\"\n";

            # replace variables in the regex too
            $chregex =~ s/\$version/$version/g;
            $chregex =~ s/\$osversion/$osversion/g;

            logmsg " Use regex \"$chregex\"\n";
            #$chregex = quotemeta($chregex);
            my $l;
            my $match;
            for $l (@data) {
              #  print "$l\n";
                if($l =~ /$chregex/) {
                    my $r = $1;
                    if($versionembedded) {
                        # '$version' was part of the URL and thus we don't
                        # need/want to extract it from the regex match
                        $r = $version;
                    }
                    $match++;
                    logmsg " Remote version found: $r\n";
                    logmsg sprintf " Present database version: %s\n",
                    $$ref{'curl'};

                    if($$ref{'curl'} ne $r) {
                        # TODO: actually store the new version here
                        $update++;
                        logmsg " NEWER version found!\n";
                        $$ref{'remdate'} = timestamp();
                        $$ref{'curl'}=$r;
                        if($versionembedded) {
                            # the version string is embedded in the test URL
                            # so we update the download URL as well!
                            $$ref{'file'}=$churl;
                            logmsg " Updated download URL!\n";
                        }
                    }
                    else {
                        $uptodate++;
                        logmsg " NOT updated\n";
                    }
                    last;
                }
            }
            logmsg " NO line matched the regex!\n" if(!$match);
        }
        else {
            # since there's no regex, just do a head request to verify the
            # file's mere existance
            @data = geturl($churl, 1);

            # store version as of now
            my $ver = $version;

            if($versionembedded) {
                #
                # Only scan for older URLs if the $version is part of it
                #

                my @five = getlast5versions();

                shift @five; # we already tried the latest

                # while no data was received, try older versions
                while(!content_length(@data) && @five) {
                    $ver = shift @five;
                    $churl = $inurl;
                    $churl =~ s/\$version/$ver/g;
                    $churl =~ s/\$osversion/$osversion/g;
                    
                    logmsg " Retry with version $ver: \"$churl\"\n";
                    @data = geturl($churl, 1);

                    if($ver eq $$ref{'curl'}) {
                        # no need to scan for older packages than what we
                        # already have
                        logmsg " Ending scan here, $ver is database version\n";
                        last;
                    }
                }
            }

            if(!content_length(@data)) {
                logmsg sprintf(" None of the 5 latest versions found! Database contains version %s\n",
                               $$ref{'curl'});
                logmsg " NOT updated\n";
                $failedcheck++;
                next;
            }

            logmsg " Remote version found: $ver\n";
            logmsg sprintf " Present database version: %s\n", $$ref{'curl'};
            if($$ref{'curl'} ne $ver) {
                # TODO: actually store the new version here
                $update++;
                logmsg " NEWER version found!\n";
                $$ref{'remdate'} = timestamp();
                $$ref{'curl'} = $ver;
                if($versionembedded) {
                    # the version string is embedded in the test URL
                    # so we update the download URL as well!
                    $$ref{'file'}=$churl;
                    logmsg " Updated download URL!\n";
                }
            }
            else {
                $uptodate++;
                logmsg " NOT updated\n";
            }
        }
    }
    else {
        $missing++;
    }
}

logmsg "*** SUMMARY ***\n";
logmsg "$uptodate packages found up-to-date\n";
logmsg "$failedcheck packages failed to get checked\n";
logmsg "$localpackage packages are local and taken care of differently\n";

if($missing) {
    logmsg "$missing listed packages lacked autocheck URL\n";
}

# one or more updated entries, save!
# we have updated time stamps after each run, always save!
$db->save();

logmsg "$update packages updated\n";

