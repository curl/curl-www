#!/usr/bin/env perl

while(<STDIN>) {

    if($_ =~ /<!--\#exec cmd=\"(.*)\" -->/) {
        $cmd = $1;
        print `$cmd`;
    }
    else {
        print $_;
    }
}
