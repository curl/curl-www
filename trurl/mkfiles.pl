#!/usr/bin/perl

#use Time::localtime;
use POSIX qw(strftime);

my $url="/trurl/";

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
    if($file =~ /^trurl-([0-9.-]+)\.(tar\.gz)$/) {
        my ($version, $ext)=($1, $2);
        $file{$version}=$file;
        my $fsize = filesize("$dl/$file");
        $size{$version}=sprintf("%.1f KB", $fsize/1024);

        my $when = filetime("$dl/$file");
        my $d = strftime "%Y-%m-%d", gmtime($when);
        $date{$version}=$d;
        $versions{$version}++;
        if(-e "$dl/$file.asc") {
            # a GPG signature
            $gpg{$version}="$dl/$file.asc";
        }
    }
}

sub num {
    my ($t)=@_;
    my $n;
    if($t =~ /.*(\d+)\.(\d+)\.(\d+)/) {
        $n = 10000*$1 + 100*$2 + $3;
    }
    elsif($t =~ /.*(\d+)\.(\d+)/) {
        $n = 10000*$1 + 100*$2;
    }
    return $n;
}

my %video = (
    '0.15' => 'https://youtu.be/ETxhkW2SsfU',
    '0.16' => 'https://youtu.be/X8auKKxgFpw',
    );

my $gen=0;
for my $version (reverse sort { num($a) <=> num($b) } keys %versions) {
    my $build = 1;
    my $officialver = $version;
    if($officialver =~ s/-(\d)\z//g) {
        $build = $1;
    }
    my $link = $officialver;
    print "#define TRURL_VER $officialver\n";
    print "#define TRURL_VER_LINK trurl-$officialver\n\n";

    printf("#define TRURL_FILENAME dl/%s\n", $file{$version});
    printf("#define TRURL_SIZE %s\n", $size{$version});
    printf("#define TRURL_DATE %s\n", $date{$version});

    if($gpg{$version}) {
        printf("#define TRURL_SIG %s\n", $gpg{$version});
    }

    my $sha = checksum("$dl/$file{$version}");
    printf("#define TRURL_SHA256 %s\n", $sha);

    if($video{$officialver}) {
        printf("#define TRURL_VIDEO %s\n", $video{$officialver});
    }

    last;
}

