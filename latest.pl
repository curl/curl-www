#!/usr/bin/perl

use strict;
use latest;

my %mirrors=(
    'https://curl.askapache.com/' => 'US (Houston, Texas)',

    # Gautam Mani runs
    'https://execve.net/mirror/curl/' => 'Singapore',

    # Marc Hoersken runs:
    'https://dl.uxnr.de/mirror/curl/' => 'Germany (Nuremberg, Bavaria)',

    # Marty Anstey runs:
    #'https://curl.mirror.anstey.ca/' => 'Canada (Vancouver)',
    );

sub present {
    my ($site, $file)=@_;
    my $res=0;
    my $code=200;

    if($site =~ /^ftp:/i) {
        # FTP check
        $res =
            system("$latest::curl -f -m 10 -I ${site}${file} -o /dev/null -s");
        $res >>= 8;
    }
    else {
        $code = `$latest::curl -f -m 10 -I ${site}${file} -s | egrep -i "(HTTP/([012.]*) 200|Content-Length:)" | wc -l`;
        # the above should match two lines and thus result in '2' if fine I
        # check for Content-Length: too since too many dead/parked servers
        # return 200 for everything.
        $code *= 100;
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

    printf("DOWNLOAD: %s %s Fastly (worldwide)\n", $archive,
           "https://curl.haxx.se/download/$archive");

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
