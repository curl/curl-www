#!/usr/bin/perl

use strict;
use latest;

my @mirrors=('ftp://ftp.sunet.se/pub/www/utilities/curl/',
             'http://cool.haxx.se/curl/',
             'ftp://ftp.fu-berlin.de/pub/unix/network/curl/',
             'http://curl.linuxworx.com.au/',
             'ftp://ftp.rge.com/pub/networking/curl/',
             'http://www.cubic.ch/mirror/curl/',
             'http://curl.webmeta.com/',
             'ftp://gd.tuwien.ac.at/utils/archivers/curl/',
             'http://gd.tuwien.ac.at/utils/archivers/curl/',
             'http://telia.dl.sourceforge.net/sourceforge/curl/',
             'http://unc.dl.sourceforge.net/sourceforge/curl/',
             'http://belnet.dl.sourceforge.net/sourceforge/curl/',
             'http://west.dl.sourceforge.net/sourceforge/curl/',
             #'http://prdownloads.sourceforge.net/curl/',
             'ftp://ftp.debian.org/mounts/u3/sourceforge/curl/',
             'ftp://ftp.falsehope.com/home/tengel/curl/'
             );

sub present {
    my ($site, $file)=@_;

    my $res = system("$latest::curl -f -m 120 -I ${site}${file} -o /dev/null -s");
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

    printf("DOWNLOAD: %s %s\n", $archive,
           "http://curl.haxx.se/download/$archive");

    for(@mirrors) {
        my $site=$_;
        if(present($site, $archive)) {
            printf("DOWNLOAD: %s %s\n", $archive,
                   "${site}${archive}");
        }
    }
}
