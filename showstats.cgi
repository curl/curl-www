#!/usr/bin/perl

$stat = $ARGV[0];

if($stat eq "hits") {
    open(HITS, "<stats/top/hits");
    @hits=<HITS>;
    close(HITS);
    print @hits;
}
elsif($stat eq "packs") {
    open(PAGES, "<stats/top/pages");
    while(<PAGES>) {
        if($_ =~ / *(\d*) (.*)curl-([^ ]*)\.(zip|rpm|gz|bz2|tgz)$/) {
            $packs += $1;
        }

    }
    close(PAGES);

    print "$packs\n";
}
