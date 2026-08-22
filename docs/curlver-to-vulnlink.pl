#!/usr/bin/env perl

my $versions = shift @ARGV;

if(!$versions) {
    die "no VERSIONS.md path provided\n";
}

my %exists;
my %solid;
open(V, "<$versions") or die "Failed to open $versions: $!\n";
while(<V>) {
    if(/^- ([45678][0-9.]*):/) {
        $exists{$1} = 1;
    }
    elsif(/^- Rock-solid curl (8.[0-9.]*):/) {
        $solid{$1} = 1;
    }
}
close(V);

sub inject {
    my ($version) = @_;
    if($exists{$version}) {
        return "<a href=\"vuln-$version.html\">$version</a>";
    }
    elsif($solid{$version}) {
        return "<a title=\"Rock-solid curl $version\" href=\"https://rock-solid.curl.dev/download.html\">$version</a>";
    }
    return $version;
}

while(<STDIN>) {
    $_ =~ s/([45678]\.[0-9.]*)/inject($1)/eg;
    $_ =~ s/(CURLOPT_([A-Z0-9_]+))/<a href="https:\/\/curl.se\/libcurl\/c\/$1.html">$1<\/a>/g;
    print $_;
}
