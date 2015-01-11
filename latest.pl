#!/usr/bin/perl

use strict;
use latest;

my %mirrors=(
    'ftp://ftp.sunet.se/pub/www/utilities/curl/' => 'Sweden (Uppsala)',
    'http://curl.askapache.com/download/' => 'US (Indiana)',
    'http://curl.mirror.at.stealer.net/download/' => 'Germany (Nuernberg)',
    'ftp://gd.tuwien.ac.at/utils/archivers/curl/' => 'Austria (Vienna)',
    'ftp://ftp.planetmirror.com/pub/curl/' => 'Australia',
    'http://curl.nedmirror.nl/download/' => 'Netherlands (Amsterdam)',
    'http://curl.online-mirror.de/download/' => 'Germany (Cologne)',
    'http://curl.oslevel.de/download/' => 'Germany (Karlsruhe)',
    'http://dl.ambiweb.de/mirrors/curl.haxx.se/' => 'Germany (Erfurt)',
    'http://mirror.weathercity.com/curl/' => 'Canada (Vancouver)',
    'http://www.execve.net/curl/' => 'Singapore',
    'http://dl.uxnr.de/os/curl/download/' => 'Germany (St. Wendel, Saarland)',
    'https://psh01ams3.uxnr.de/mirror/curl/' => 'Netherlands (Amsterdam)',
    'https://psh02sgp1.uxnr.de/mirror/curl/' => 'Singapore',
    );

sub present {
    my ($site, $file)=@_;
    my $res=0;
    my $code=200;

    if($site =~ /^ftp:/i) {
        # FTP check
        $res =
            system("$latest::curl -f -m 30 -I ${site}${file} -o /dev/null -s");
        $res >>= 8;
    }
    else {
        $code = `$latest::curl -f -m 30 -I ${site}${file} -o /dev/null -s -w '%{http_code}\n'`;
    }
    if($res || ($code != 200)) {
        # FTP or HTTP error condition
        return 0; # not present
    }
    else {
        return 1;
    }
}

&latest::scanstatus();

for(keys %latest::file) {

    my $archive=$latest::file{$_};
    printf("ARCHIVE: %s: %s %d\n",
           $_, $archive, $latest::size{$_});

    printf("DOWNLOAD: %s %s Sweden (Stockholm)\n", $archive,
           "http://curl.haxx.se/download/$archive");

    for(keys %mirrors) {
        my $site=$_;
        if(present($site, $archive)) {
            printf("DOWNLOAD: %s %s %s\n",
                   $archive,
                   "${site}${archive}",
                   $mirrors{$site});
        }
        else {
            printf("FAILED: %s\n",
                   "${site}${archive}");
        }
    }
}
