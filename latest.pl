#!/usr/bin/perl

use strict;
use latest;

my %mirrors=('ftp://ftp.sunet.se/pub/www/utilities/curl/' => 'SE',
             'http://cool.haxx.se/curl/' => 'SE',
             'ftp://ftp.fu-berlin.de/pub/unix/network/curl/' => 'DE',
             'ftp://ftp.rge.com/pub/networking/curl/' => 'US',
             'http://www.cubic.ch/mirror/curl/' => 'CH',
             'http://curl.webmeta.com/' => '?',
             'ftp://gd.tuwien.ac.at/utils/archivers/curl/' => 'AT',
             'http://gd.tuwien.ac.at/utils/archivers/curl/' => 'AT',
             'http://curl.sourceforge.net/download/' => 'US (CA)',
             'http://www.planetmirror.com/pub/curl/' => 'AU',
             'ftp://ftp.planetmirror.com/pub/curl/' => 'AU',
             'http://www.execve.net/curl/' => 'HK',
             'http://curl.tsuren.net/download/' => 'RU',
             'http://curl.cyberservers.net/download/' => 'US (TX)',
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

    printf("DOWNLOAD: %s %s SE\n", $archive,
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
