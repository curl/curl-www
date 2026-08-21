#!/usr/bin/env perl

my $versions = shift @ARGV;

if(!$versions) {
    die "no VERSIONS.md path provided";
}

my %exists;
open(V, "<$versions");
while(<V>) {
    if(/^- ([45678][0-9.]*):/) {
        $exists{$1} = 1;
    }
}
close(V);

sub inject {
    my ($version) = @_;
    if($exists{$version}) {
        return "<a href=\"vuln-$version.html\">$1<\/a>";
    }
    return $version;
}

while(<STDIN>) {
    $_ =~ s/([45678][0-9.]*)/inject($1)/eg;
    $_ =~ s/(CURLOPT_([A-Z0-9_]+))/<a href="https:\/\/curl.se\/libcurl\/c\/$1.html">$1<\/a>/g;
    print $_;
}
