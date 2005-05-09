#!/usr/bin/perl

require "../latest.pm";
require "stuff.pm";

# get database
$db=new pbase;
$db->open($databasefilename);

my $mod; # number of changes made

&latest::scanstatus();

@all = $db->find_all("typ"=>"^entry\$");

print "\$version = $latest::headver\n";
my $version = $latest::headver;

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

my $curlcmd="curl -fsm20 ";

my $update;
my $ref;
for $ref (@all) {
    my $inurl = $$ref{'churl'};
    my $chregex = $$ref{'chregex'};
    my $churl = $inurl;
    if($churl) {
        # there's a URL to check
        # expand $version!
        $churl =~ s/\$version/$version/g;

        print "Get CHURL $churl\n";

        my @data = `$curlcmd $churl`;

        if($chregex) {
            if(!$data[0]) {
                print STDERR "CHURL $churl failed, no such URL or dead for now\n";
                next;
            }

            # there's a regex to check for in the downloaded page
            $chregex = CGI::unescapeHTML($chregex);
            print "Get CHREGEX $chregex\n";
            #$chregex = quotemeta($chregex);
            my $l;
            for $l (@data) {
              #  print "$l\n";
                if($l =~ /$chregex/) {
                    my $r = $1;
                    print "Remote version found: $r\n";
                    printf "Present database version: %s\n", $$ref{'curl'};

                    if($$ref{'curl'} ne $r) {
                        # TODO: actually store the new version here
                        $update++;
                    }
                    else {
                        print "not updated\n";
                    }
                    last;
                }
            }
            print "No line matched the regex!\n";
        }
        else {
            my @five = getlast5versions();

            shift @five; # we already tried the latest

            # while no data was received, try older versions
            my $ver = $version;

            while(!$data[0] && @five) {
                $ver = shift @five;
                $churl = $inurl;
                $churl =~ s/\$version/$ver/g;

                print "Try same URL with version $ver: $churl!\n";
                my @data = `$curlcmd $churl`;
            }

            if(!$data[0]) {
                print STDERR "None of the 5 latest versions found!\n";
                next;
            }

            print "Remote version found: $ver\n";
            printf "Present database version: %s\n", $$ref{'curl'};
            if($$ref{'curl'} ne $version) {
                # TODO: actually store the new version here
                $update++;
            }
            else {
                print "not updated\n";
            }
        }
    }
}

if($update) {
    # one or more updated entries, save!
    #$db->save();
    print "$update changes saved\n";
}
