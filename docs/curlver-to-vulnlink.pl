#!/usr/bin/perl

while(<STDIN>) {
    if($_ =~ s/([78]\.(\d+)\.(\d+))/<a href="vuln-$1.html">$1<\/a>/g) {
        # to avoid that 7.X matches a substring of a longer version like
        # 7.1 in 7.17.1
        ;
    }
    $_ =~ s/(7\.[1-9])([^0-9\.])/<a href="vuln-$1.html">$1<\/a>$2/g;
    $_ =~ s/(CURLOPT_([A-Z0-9_]+))/<a href="https:\/\/curl.se\/libcurl\/c\/$1.html">$1<\/a>/g;
    print $_;
}
