#!/usr/bin/perl

use strict;
use latest;

my %mirrors=('ftp://ftp.sunet.se/pub/www/utilities/curl/' => 'Sweden (Uppsala)',
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

#             'http://gd.tuwien.ac.at/utils/archivers/curl/' => 'Austria (Vienna)',
#             'http://www.mirrorspace.org/curl/' => 'Germany (Bonn)',
#             'http://curl.netmirror.org/download/' => 'Germany (Frankfurt)',
#             'http://curl.cofman.dk/download/' => 'Denmark',
#             'http://curl.signal42.com/download/' => 'US (California)',
#             'http://curl.cs.pu.edu.tw/download/' => 'Taiwan',
#             'http://curl.freemirror.de/download/' => 'Germany (Düsseldorf)',
#             'http://curl.mirroring.de/download/' => 'Germany (Karlsruhe)',
#             'http://curl.miscellaneousmirror.org/download/' =>
#              'Germany (Cologne)',
#             'http://curl.hostingzero.com/download/' => 'US (Texas)',
#             'http://curl.hoxt.com/download/' => 'US (Florida)',
#             'http://curl.s-lines.net/download/' => 'Japan (Shizuoka)',
#             'http://curl.linux-mirror.org/download/' => 'Germany (Cologne)',
#             'http://curl.download.nextag.com/download/' => 'US (California)',
#             'http://curl.osmirror.nl/download/' => 'Netherlands (Amsterdam)',
#             'http://curl.de-mirror.de/download/' => 'Germany (Aachen)',
#             'http://curl.internet.bs/download/' => 'United Kingdom (London)',
#             'ftp://miroir-francais.fr/pub/curl/download/' => 'France (Paris)',
#             'http://curl.dsmirror.nl/download/' => 'Netherlands (Amsterdam)',
#             'http://curl.basemirror.de/download/' => 'Germany (Nuremberg)',
#             'http://curl.xxtracker.org/download/' => 'Netherlands (Amsterdam)',
#             'ftp://ftp.spegulo.be/pub/curl/' => 'Belgium (Antwerpen)',
#             'http://curl.piotrkosoft.net/download/' => 'Poland (Oswiecim)',
#             'http://curl.smudge-it.co.uk/download/' => 'United Kingdom (London)', 
#             'http://curl.freeby.pctools.cl/download/' => 'Chile (Santiago)',
#             'http://curl.cheap.co.il/download/' => 'Israel (Tel-Aviv)',
#             'http://curl.digimirror.nl/download/' => 'Netherlands (Amsterdam)',
#             'http://curl.wetzlmayr.at/download/' => 'USA (Los Angeles)',
#             'http://curl.gominet.net/download/' => 'Portugal (Vizcaya)',
#             'http://curl.very-clever.com/download/' => 'Germany (Nuremberg)',
#             'http://curl.sommerhusguide.dk/download/' => 'Denmark (Vildbjerg)',
#             'http://mirror.adriaticus.org/pub/curl/' => 'Germany (Falkenstein)',
#             'ftp://mirror.adriaticus.org/pub/curl/' => 'Germany (Falkenstein)',
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
