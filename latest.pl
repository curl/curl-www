#!/usr/bin/perl

use strict;
use latest;

my %mirrors=('ftp://ftp.sunet.se/pub/www/utilities/curl/' => 'Sweden',
             'http://cool.haxx.se/curl/' => 'Sweden',
             'ftp://ftp.fu-berlin.de/pub/unix/network/curl/' => 'Germany',
             'ftp://ftp.rge.com/pub/networking/curl/' => 'US',
             'http://www.cubic.ch/mirror/curl/' => 'Switzerland',
             'http://curl.webmeta.com/' => 'US (Connecticut)',
             'ftp://gd.tuwien.ac.at/utils/archivers/curl/' => 'Austria',
             'http://gd.tuwien.ac.at/utils/archivers/curl/' => 'Austria',
             'http://curl.mirrors.redwire.net/download/' => 'US (California)',
             'http://www.planetmirror.com/pub/curl/' => 'Australia',
             'ftp://ftp.planetmirror.com/pub/curl/' => 'Australia',
             'http://www.execve.net/curl/' => 'Hong Kong',
             'http://curl.tsuren.net/download/' => 'Russia',
#             'http://curl.cyberservers.net/download/' => 'US (Texas)',
             'http://curl.mirror.at.stealer.net/download/' => 'Germany',
             'http://curl.siamu.ac.th/download/' => 'Thailand',
             'ftp://ftp.ntua.gr/pub/linux/openpkg/sources/DST/curl/' => 'Greece',
             'http://curl.wildyou.net/download/' => 'Estonia',
             'http://www.mirrorspace.org/curl/' => 'Germany',
             'http://curl.109k.com/download/' => 'US (Texas)',
             'http://curl.netmirror.org/download/' => 'Germany',
             'http://curl.cofman.dk/download/' => 'Denmark',
             'http://curl.mirror.internet.tp/download/' => 'France',
             'http://curl.signal42.com/download/' => 'US (California)',
             'http://curl.cs.pu.edu.tw/download/' => 'Taiwan',
             'http://curl.kgt.org/download/' => 'Germany',
             'ftp://ftp.kgt.org/pub/mirrors/curl/' => 'Germany',
             'http://www.mirrormonster.com/curl/download/' => 'US (California)',
             );

sub present {
    my ($site, $file)=@_;

    my $res = system("$latest::curl -f -m 60 -I ${site}${file} -o /dev/null -s");
    if($res >> 8) {
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

    printf("DOWNLOAD: %s %s Sweden\n", $archive,
           "http://curl.haxx.se/download/$archive");

    for(keys %mirrors) {
        my $site=$_;
        if(present($site, $archive)) {
            printf("DOWNLOAD: %s %s %s\n",
                   $archive,
                   "${site}${archive}",
                   $mirrors{$site});
        }
    }
}
