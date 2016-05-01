#!/usr/bin/perl
# Generate a metalink download file
# See http://www.metalinker.org/
# Based on latest.cgi
# by Dan Fandrich

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

my $md5sum="md5sum";
my $sha256sum="sha256sum";

print "Content-Type: application/metalink4+xml\n\n";

my $req = new CGI;

# CGI::escapeHTML here should effectively be a no-op, but improves security when output
my $what=CGI::escapeHTML($req->param('curl'));

my ($mytld, $mycontinent, $mycountry);

if($what eq "") {
    printf("<!-- error: no files specified -->\n");
    exit;
}

use POSIX qw(strftime);
my $now_string = strftime "%Y-%m-%dT%H:%M:%SZ", gmtime;
print <<EOF
<?xml version="1.0" encoding="utf-8"?>
<metalink xmlns="urn:ietf:params:xml:ns:metalink">
<origin dynamic="true">https://curl.haxx.se/metalink.cgi?curl=$what</origin>
<updated>$now_string</updated>
<generator>curl Metalink Generator</generator>
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
    my $tld = country2tld($country);

    if($tld eq "uk") {
        # NOTE: this is GB, not UK, to follow the Metalink spec
        $tld="gb";
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

    my $sha256full=`$sha256sum "download/$archive"`;
    my ($sha256, $dummy)=split(" ", $sha256full);

    my $mtime = (stat("download/$archive"))[9];
    my $mtime_string = strftime "%Y-%m-%dT%H:%M:%SZ", gmtime($mtime);

    print <<EOF
<published>$mtime_string</published>
<file name="$archive">
<publisher>
 <name>curl</name>
 <url>https://curl.haxx.se/</url>
</publisher>
<description>curl $desc</description>
<version>$latest::version{$what}</version>
<size>$latest::size{$what}</size>
<hash type="md5">$md5</hash>
<hash type="sha-256">$sha256</hash>
EOF
;

    if( -r "download/$archive.asc" ) {
        print "<signature mediatype=\"application/pgp-signature\">\n";
	open(SIG, "<download/$archive.asc");
	while(<SIG>) {
	   print CGI::escapeHTML($_);
    	}
	close(SIG);
    	print "</signature>\n";
    }

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

    if($alert) {
        print "<url location=\"se\">https://curl.haxx.se/download/$archive</url>\n";
    }
    else {

        my $i=0;
        my $prio;
        for(sort {$where{$a} cmp $where{$b}} @dl) {
            my $url=$_;

            if(country2tld($where{$url}) eq lc($mytld)) {
                $prio = 10;
            }
            elsif(tld2continent( country2tld($where{$url})) eq $mycontinent) {
                $prio = 20;
            } else {
                $prio = 30;
            }

            $i++;
            printf "<url location=\"%s\" priority=\"%d\">%s</url>\n",
		    gettld($where{$url}),
		    $prio,
		    CGI::escapeHTML($url);
        }
    }
    print "</file>\n";
}
elsif($what) {
    print "<!-- The recent-version-off-a-mirror system has no info about ",
    "your requested package \"$what\", likely because there\n",
    "is no up-to-date release -->\n";
}

print "</metalink>\n";

