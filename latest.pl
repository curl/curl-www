#!/usr/bin/perl

use strict;
use latest;

my %mirrors=('ftp://ftp.sunet.se/pub/www/utilities/curl/' => 'Sweden (Uppsala)',
             'http://cool.haxx.se/curl/' => 'Sweden (Kista)',
             'ftp://ftp.rge.com/pub/networking/curl/' => 'US (New York)',
             'http://curl.webmeta.com/' => 'US (Connecticut)',
             'ftp://gd.tuwien.ac.at/utils/archivers/curl/' => 'Austria (Vienna)',
             'http://gd.tuwien.ac.at/utils/archivers/curl/' => 'Austria (Vienna)',
             'http://curl.mirrors.redwire.net/download/' => 'US (California)',
             'ftp://ftp.planetmirror.com/pub/curl/' => 'Australia',
             'http://www.execve.net/curl/' => 'Hong Kong',
             'http://curl.tsuren.net/download/' => 'Russia',
             'http://curl.mirrors.cyberservers.net/download/' => 'US (Texas)',
             'http://curl.mirror.at.stealer.net/download/' => 'Germany (Nuernberg)',
             'http://curl.siamu.ac.th/download/' => 'Thailand',
             'http://curl.wildyou.net/download/' => 'Estonia',
             'http://www.mirrorspace.org/curl/' => 'Germany (Bonn)',
             'http://curl.109k.com/download/' => 'US (Texas)',
             'http://curl.netmirror.org/download/' => 'Germany (Frankfurt)',
             'http://curl.cofman.dk/download/' => 'Denmark',
             'http://curl.signal42.com/download/' => 'US (California)',
             'http://curl.cs.pu.edu.tw/download/' => 'Taiwan',
             'http://curl.freemirror.de/download/' => 'Germany (Düsseldorf)',
             'http://www.mirrormonster.com/curl/download/' => 'US (California)',
             'http://curl.mons-new-media.de/download/' => 'Germany (Karlsruhe)',
             'http://curl.islandofpoker.com/download/' => 'US (Arizona)',
             'http://curl.tolix.org/download/' => 'US (California)',
             'http://curl.seekmeup.com/download/' => 'US (Texas)',
             'http://curl.mirroring.de/download/' => 'Germany (Karlsruhe)',
             'http://curl.meulie.net/download/' => 'US (California)',
             'http://curl.miscellaneousmirror.org/download/' =>
             'Germany (Cologne)',
             'http://curl.hostingzero.com/download/' => 'US (Texas)',
             'http://curl.mirror-server.net/download/' => 'Germany (Nuremberg)',
             'http://curl.hoxt.com/download/' => 'US (Florida)',
             'http://curl.nedmirror.nl/download/' => 'Netherlands (Amsterdam)',
             'http://curl.hkmirror.org/download/' => 'Hong Kong',
             'ftp://ftp.hkmirror.org/pub/curl/download/' => 'Hong Kong',
             'http://curl.storemypix.com/download/' => 'Germany (Berlin)',
             'http://curl.mirroarrr.de/download/' => 'Germany (Berlin)',
             'http://curl.s-lines.net/download/' => 'Japan (Shizuoka)',
             'http://curl.oss-mirror.org/download/' => 'Ireland (Dublin)',
             'http://curl.linux-mirror.org/download/' => 'Germany (Cologne)',
             'http://dl.ambiweb.de/mirrors/curl.haxx.se/' => 'Germany (Erfurt)',
             'http://curl.download.nextag.com/download/' => 'US (California)',
             'http://curl.mirroarrr.de/download/' => 'Germany (Berlin)',
             'http://curl.osmirror.nl/download/' => 'Netherlands (Amsterdam)',
             'http://curl.de-mirror.de/download/' => 'Germany (Aachen)',
             'http://curl.webdesign-zdg.de/download/' => 'Germany (Frankfurt)',
             'http://curl.oslevel.de/download/' => 'Germany (Karlsruhe)',
             'http://curl.gfiles.org/download/' => 'Russia (Vladivostok)',
             'http://curl.geosdreams.info/download/' => 'Poland (Olsztyn)',
             'http://curl.online-mirror.de/download/' => 'Germany (Cologne)',
             'http://curl.blogvoid.com/download/' => 'Canada (Montreal)',
             'http://curl.internet.bs/download/' => 'United Kingdom (London)',
             'http://curl2.haxx.se/download/' => 'Sweden (Stockholm)',
             'http://curl.miroir-francais.fr/download/' => 'France (Paris)',
             'ftp://miroir-francais.fr/pub/curl/download/' => 'France (Paris)',
             'http://curl.dsmirror.nl/download/' => 'Netherlands (Amsterdam)',
             'http://curl.basemirror.de/download/' => 'Germany (Nuremberg)',
             'http://curl.xxtracker.org/download/' => 'Netherlands (Amsterdam)',
             'http://curl.spegulo.be/download/' => 'Belgium (Antwerpen)',
             'ftp://ftp.spegulo.be/pub/curl/' => 'Belgium (Antwerpen)',
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

    printf("DOWNLOAD: %s %s Sweden (Kista)\n", $archive,
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
