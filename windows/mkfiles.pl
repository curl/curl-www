#!/usr/bin/perl

#use Time::localtime;
use POSIX qw(strftime);

my $url="/windows/";

sub getdl {
    my ($dir)=@_; # where the download files are
    opendir(DIR, $dir) || die "can't opendir $dir: $!";
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

my @alldeps;
sub depversions {
    my ($dl) = @_;
    open(D, "<$dl/build.txt");
    my $tools;
    while(<D>) {
        if($_ =~ /^\.(.*)/) {
            # tools
            $tools .= "<li>$1";
        }
        elsif($_ =~ /^([^.]\S+) (\S+)/) {
            my ($dep, $ver) = ($1, $2);
            my $u = $ver;
            $u =~ s/\./_/g;
            printf("#define DEP_%s %s\n", uc($dep), $ver);
            printf("#define DEPU_%s %s\n", uc($dep), $u);
            $depver{$dep}=$ver;
            push @alldeps, $dep;
        }
    }
    close(D);
    printf "#define DEP_TOOLS %s\n", $tools;
}

sub latest {
    open(F, "<latest.txt") ||
        die "no 'latest.txt' present!";
    my @f = <F>;
    close(F);
    chomp $f[0];
    return "dl-$f[0]";
}

sub gethashes {
    my ($dir)=@_; # where the download files are
    open(H, "$dir/hashes.txt") ||
        die "no hashes!";
    while(<H>) {
        if($_ =~ /^SHA256\(([^)]*)\)= (.*)/) {
            my ($file, $hash)=($1, $2);
            if($file =~ /^([^-]*)-.*-([^-]*)-mingw.zip/) {
                my ($dep, $arch) = ($1, $2);
                printf("#define SHA256_%s_%s %s\n",
                       uc($dep), uc($arch), $hash);
            }
        }
    }
    close(H);
}

sub getlog {
    my ($dir)=@_; # where the download files are
    open(L, "$dir/logurl.txt") || return;
    my @l = <L>;
    close(L);
    chomp $l[0];
    printf "#define BUILD_LOGURL %s\n", $l[0];
}

my $dl = latest();

my @files = getdl($dl);
for(@files) {
    my $file = $_;
    if($file =~ /^curl-([0-9.]*_[0-9]*)-(\S+)-(\S+)\.(\S+)/) {
        my ($version, $arch, $env, $ext)=($1, $2, $3, $4);
        $exts{$version}.="$ext,";
        $archs{$version.$ext}.="$arch,";
        $allext{$ext}++;
        $file{$version.$arch.$ext}=$file;
        $size{$version.$arch.$ext}=sprintf("%.1f MB",
                                           filesize("$dl/$file")/(1024*1024));

        my $when = filetime("$dl/$file");
        my $d = strftime "%Y-%m-%d", gmtime($when);
        $date{$version.$arch.$ext}=$d;
        push @versions, $version;
    }
}

my $gen=0;
for my $version (reverse sort @versions) {
    print "#define CURL_WINDOWS_VERSION $version\n";
    if($version =~ /([0-9.]*)_(\d)/) {
        $gen = $2;
    }
    print "#define CURL_PACKAGE_GEN $gen\n";
    for my $ext ('zip', 'xz') {
        for my $arch (split(',', $archs{$version.$ext})) {
            printf("#define CURL_%s_%s $dl/curl-%s-%s-mingw.%s\n",
                   uc($arch), uc($ext), $version,
                   lc($arch), lc($ext));
            printf("#define CURL_%s_%s_SIZE %s\n",
                   uc($arch), uc($ext), $size{$version.$arch.$ext});
            printf("#define CURL_%s_%s_DATE %s\n",
                   uc($arch), uc($ext), $date{$version.$arch.$ext});
        }
    }
    last;
}
depversions($dl);

# generate downlowd links for deps
for(@alldeps) {
    for my $arch ('win32', 'win64') {
        printf "#define DL_%s_%s %s/%s-%s_%d-%s-mingw.zip\n",
        uc($_), uc($arch), $dl, $_, $depver{$_}, $gen, $arch;
    }
}

gethashes($dl);

getlog($dl);
