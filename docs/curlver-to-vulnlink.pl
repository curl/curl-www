#!/usr/bin/perl

while(<STDIN>) {
    if($_ =~ s/(7\.(\d+)\.(\d+))/<a href="vuln-$1.html">$1<\/a>/g) {
        # to avoid that 7.X matches a substring of a longer version like
        # 7.1 in 7.17.1
        ;
    }
    else {
        $_ =~ s/(7\.[1-9])[^0-9\.]/<a href="vuln-$1.html">$1<\/a>/g;
    }
    $_ =~ s/(CURLOPT_([A-Z0-9_]+))/<a href="https:\/\/curl.haxx.se\/libcurl\/c\/$1.html">$1<\/a>/g;
    print $_;
}
