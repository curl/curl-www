#!/usr/bin/perl

$stat = $ARGV[0];

if($stat eq "hits") {
    if(open(HITS, "<stats/top/hits")) {
        @hits=<HITS>;
        close(HITS);
    }
    else {
        $hits[0]="many";
    }
    print $hits[0];
}
elsif($stat eq "packs") {
    if(open(PAGES, "<stats/top/pages")) {
        while(<PAGES>) {
            if($_ =~ / *(\d*) (.*)curl-([^ ]*)\.(zip|rpm|gz|bz2|tgz)$/) {
                $packs += $1;
            }
            
        }
        close(PAGES);
    }
    else {
        $packs = "numerous";
    }
    print "$packs\n";
}
