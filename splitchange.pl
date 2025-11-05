#!/usr/bin/perl

my $dir = "ch";
my $ver;
my $date;
my $fh;

my @header;
my @footer;

open(H, "<", "_single-head-template.html");
@header=<H>;
close(H);

open(F, "<", "_single-foot-template.html");
@footer=<F>;
close(F);

sub add {
    print $fh "#define VERSION $ver\n";
    if($nextver{$ver}) {
        print $fh "#define NEXTVERSION $nextver{$ver}\n";
    }
    if($prevver{$ver}) {
        print $fh "#define PREVVERSION $prevver{$ver}\n";
    }
    if($releasedate{$ver}) {
        print $fh "#define RELEASEDATE $releasedate{$ver}\n";
    }
    for my $l (@_) {
        print $fh $l;
    }
}

# parse _changes.html once to get all versions
open(C, "<", "_changes.html");
while(<C>) {
    my $l = $_;
    # each release starts with this
    if($l =~ /^SUBTITLE\(Fixed in ([0-9.]+) - (.*)\)/) {
        my $version=$1;
        my $date=$2;
        $nextver{$version} = $ver;
        $prevver{$ver} = $version;
        $releasedate{$version} = $date;
        $ver = $version;
        push @releases, $ver;
    }
}
close(C);

# split _changes.html into separate pages
open(C, "<", "_changes.html");
while(<C>) {
    my $l = $_;
    # each release starts with this
    if($l =~ /^SUBTITLE\(Fixed in ([0-9.]*) - (.*)\)/) {
        $ver=$1;
        open($fh, ">", "$dir/$ver.gen");
        add(@header);
    }
    elsif($l =~  /^(\<a name=\"(\d)|\#)/) {
        print $fh @footer if($fh);
        close($fh) if($fh);
        undef $fh;
    }
    elsif($fh) {
        print $fh $_;
    }
}
close($fh);
close(C);

open(M, ">", "$dir/make.inc");
print M <<HEAD
ROOT=..
SRCROOT=../cvssource
DOCROOT=\$(SRCROOT)/docs

include \$(ROOT)/mainparts.mk
include \$(ROOT)/setup.mk

MAINPARTS += ../alert.t
HEAD
    ;
print M "all: index.html ";

for my $r (@releases) {
    print M "$r.html ";
}
print M "\n\n";

print M "index.html: $releases[0].gen \$(MAINPARTS)\n".
        "\t\$(ACTION)\n\n";

for my $r (@releases) {
    print M "$r.html: $r.gen \$(MAINPARTS)\n".
            "\t\$(ACTION)\n\n";
}
close(M);
