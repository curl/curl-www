#!/usr/bin/perl

#use Time::localtime;
use POSIX qw(strftime);

my $url="/qnx/";

sub getdl {
    my ($dir)=@_; # where the download files are
    opendir(DIR, $dir) || return "";
    my @files = readdir(DIR);
    closedir DIR;
    return @files;
}

sub filetime {
    my ($filename)=@_;

    my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
        $atime,$mtime,$ctime,$blksize,$blocks)
        = stat($filename);

    return $mtime;
}

sub filesize {
    my ($filename)=@_;

    my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
        $atime,$mtime,$ctime,$blksize,$blocks)
        = stat($filename);

    return $size;
}

sub checksum {
    my ($f) = @_;
    my @o = `sha256sum $f 2>/dev/null`;
    my $sh = $o[0];
    $sh =~ s/([^ ]*).*/$1/;
    chomp $sh;
    return $sh;
}


my $dl = "dl";
my @files = getdl($dl);

for(@files) {
    my $file = $_;
    if($file =~ /^curl-([0-9.-]+)-qnxsdp(\S+)\.(tar\.gz)$/) {
        my ($version, $sdk, $ext)=($1, $2, $3, $4);
        $sdk =~ s/[^0-9]//; # remove non-digits from SDK
        $sdk{$version}.="$sdk,";
        $file{$version.$sdk}=$file;
        my $fsize = filesize("$dl/$file");

        $size{$version.$sdk}=sprintf("%.1f MB", $fsize/(1024*1024));

        my $when = filetime("$dl/$file");
        my $d = strftime "%Y-%m-%d", gmtime($when);
        $date{$version.$sdk}=$d;
        $versions{$version}++;
        if(-e "$dl/$file.asc") {
            # a PGP signature
            $pgp{$version.$sdk}="$dl/$file.asc";
        }
    }
}

sub num {
    my ($t)=@_;
    if($t =~ /^(\d)\.(\d+)\.(\d+)-(\d+)/) {
        return 1000000*$1 + 10000*$2 + 100*$3 + $4;
    }
    return 0;
}

my $gen=0;
for my $version (reverse sort { num($a) <=> num($b) } keys %versions) {
    my $build = 1;
    my $officialver = $version;
    if($officialver =~ s/-(\d)\z//g) {
        $build = $1;
    }
    my $link = $officialver;
    $link =~ s/\./_/g;
    print "#define QNX_CURLVER $officialver\n";
    print "#define QNX_CURLVER_PACKAGE $version\n";
    print "#define QNX_CURLVER_LINK curl-$link\n\n";

    for my $s (sort split(',', $sdk{$version})) {
        printf("#define QNX_SDK%s_FILENAME dl/%s\n", $s, $file{$version.$s});
        printf("#define QNX_SDK%s_SIZE %s\n", $s, $size{$version.$s});
        printf("#define QNX_SDK%s_DATE %s\n", $s, $date{$version.$s});

        if($pgp{$version.$s}) {
            printf("#define QNX_SDK%s_SIG %s\n", $s, $pgp{$version.$s});
        }

        my $sha = checksum("$dl/$file{$version.$s}");
        printf("#define QNX_SDK%s_SHA256 %s\n", $s, $sha);
    }
    last;
}

