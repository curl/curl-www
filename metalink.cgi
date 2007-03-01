#!/usr/bin/perl
# Generate a metalink download file
# See http://www.metalinker.org/
# Based on latest.cgi by Dan Fandrich

require "CGI.pm";
require "ipwhere.pm";

use strict;
use latest;

require "curl.pm";

my %name;
my %size;
my %download;
my %proto;
my %host;
my %archtype;
my %where;

my $md5sum="md5sum";#/home/dast/solaris/bin/md5sum";
my $sha1sum="sha1sum";

print "Content-Type: application/metalink+xml\n\n";

my $req = new CGI;

# CGI::escapeHTML here should effectively be a no-op, but improves security when output
my $what=CGI::escapeHTML($req->param('curl'));

my ($mytld, $mycontinent, $mycountry);

if($what eq "") {
    printf("<!-- error: no files specified -->\n");
    exit;
}

use POSIX qw(strftime);
my $now_string = strftime "%a, %e %b %Y %H:%M:%S GMT", gmtime;
print <<EOF
<?xml version="1.0" encoding="utf-8"?>
<metalink version="3.0" generator="curl Metalink Generator" xmlns="http://www.metalinker.org/"
type="dynamic" refreshdate="$now_string">
<publisher>
<name>curl</name>
<url>http://curl.haxx.se/</url>
</publisher>
EOF
;


# check what's available right *now*
&latest::scanstatus();

open(DATA, "<latest.curl");
while(<DATA>) {
    chomp; # remove newline
    if($_ =~ /^ARCHIVE: ([^:]*): ([^ ]*) (\d*)/) {
        my $type=$1;
        my $archive=$2;
        my $size=$3;

        $name{$type}=$archive;
        $size{$type}=$size;

        $archtype{$archive}=$type;
    }
    elsif($_ =~ /^DOWNLOAD: ([^ ]*) ([^ ]*) (.*)/) {
        my ($archive, $curl, $where)=($1, $2, $3);

        my $proto = uc($curl);

        $proto =~ s/^(FTP|HTTP).*/$1/g;

        my $host = $curl;
        $host =~ s/^(FTP|HTTP):\/\/([^\/]*).*/$2/ig;

        $download{$archive} .= "$curl|||";
        $proto{$curl}=$proto;
        $host{$curl}=$host;
        $where{$curl}=$where;
    }
      
}
close(DATA);

sub gettld {
    my ($country)=@_;
    my $tld;

    if($country =~ /Australia/) {
        $tld="au";
    }
    elsif($country =~ /Austria/) {
        $tld="at";
    }
    elsif($country =~ /Canada/) {
        $tld="ca";
    }
    elsif($country =~ /Denmark/) {
        $tld="dk";
    }
    elsif($country =~ /Estonia/) {
        $tld="ee";
    }
    elsif($country =~ /France/) {
        $tld="fr";
    }
    elsif($country =~ /Netherlands/) {
        $tld="nl";
    }
    elsif($country =~ /Germany/) {
        $tld="de";
    }
    elsif($country =~ /Greece/) {
        $tld="gr";
    }
    elsif($country =~ /Hong Kong/) {
        $tld="hk";
    }
    elsif($country =~ /Ireland/) {
        $tld="ie";
    }
    elsif($country =~ /Japan/) {
        $tld="jp";
    }
    elsif($country =~ /Poland/) {
        $tld="pl";
    }
    elsif($country =~ /Russia/) {
        $tld="ru";
    }
    elsif($country =~ /Sweden/) {
        $tld="se";
    }
    elsif($country =~ /Thailand/) {
        $tld="th";
    }
    elsif($country =~ /Taiwan/) {
        $tld="tw";
    }
    elsif($country =~ /US/) {
        $tld="us";
    }
    elsif($country =~ /United Kingdom/i) {
        $tld="uk";
    }
    return $tld;
}

if($latest::version{$what}) {
    my $archive=$name{$what};
            
    my @dl =split('\|\|\|', $download{$archive});
            
    # set to 1 if the local file is newer than the mirrors!
    my $alert=0;
    
    my $desc=$latest::desc{$what};

    if($latest::file{$what} ne $archive) {
        # there's a newer local file!
        $archive=$latest::file{$what};
        $alert = 1;
        $size{$_} = $latest::size{$what};
    }

    my $md5full=`$md5sum "download/$archive"`;
    my ($md5, $file)=split(" ", $md5full);

    my $sha1full=`$sha1sum "download/$archive"`;
    my ($sha1, $dummy)=split(" ", $sha1full);

    print "<description>curl $desc</description>\n",
    	  "<files><file name=\"$archive\">\n",
    	  "<version>".$latest::version{$what}."</version>\n",
    	  "<size>".$latest::size{$what}."</size>\n",
    	  "<verification>\n",
    	  "<hash type=\"md5\">".$md5."</hash>\n",
    	  "<hash type=\"sha1\">".$sha1."</hash>\n";

    if( -r "download/$archive.asc" ) {
        print "<hash type=\"pgp\" file=\"$archive.asc\">\n";
	open(SIG, "<download/$archive.asc");
	while(<SIG>) {
	   print CGI::escapeHTML($_);
    	}
	close(SIG);
    	print "</hash>\n";
    }
    print "</verification>\n";

    my $myip = $ENV{'REMOTE_ADDR'} || "193.15.23.28";

    ($mytld, $mycontinent, $mycountry) = mycountry($myip);
    #($mytld, $mycontinent, $mycountry) = ("NO", "Oceania", "NORWAY");

    if ($mycountry eq "") {
	$mycountry = $mycontinent;
	if ($mycountry eq "") {
	   $mycountry = "an unknown location";
	}
    } else {
    	$mycountry = ucfirst(lc($mycountry));
    }
    print "<!-- resource preferences are for use in $mycountry -->\n";

    print "<resources>\n";

    if($alert) {
        print "<url type=\"http\" location=\"se\">http://curl.haxx.se/download/$archive</url>\n";
    }
    else {

        my $i=0;
        my $pref;
        for(sort {$where{$a} cmp $where{$b}} @dl) {
            my $url=$_;

            if(gettld($where{$url}) eq lc($mytld)) {
                $pref = 90;
            }
            elsif(tld2continent( gettld($where{$url})) eq $mycontinent) {
                $pref = 70;
            } else {
                $pref = 30;
            }

            $i++;
            printf "<url type=\"%s\" location=\"%s\" preference=\"%d\">%s</url>\n",
		    lc($proto{$url}),
		    gettld($where{$url}),
		    $pref,
		    CGI::escapeHTML($url);
        }
    }
    print "</resources>\n";
    print "</file></files>\n";
}
elsif($what) {
    print "<!-- The recent-version-off-a-mirror system has no info about ",
    "your requested package \"$what\", likely because there\n",
    "is no up-to-date release -->\n";
}

print "</metalink>\n";

