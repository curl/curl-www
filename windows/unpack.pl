#!/usr/bin/perl

my $uploadpath="/home/curl-for-win";
my $pattern="^all-mingw-([0-9._]*).zip.txt";
my $extract="dl";
my $latest="latest.txt";

opendir(DIR, $uploadpath) || exit;
my @ul = grep { /$pattern/ } readdir(DIR);
closedir DIR;

my @sul = reverse sort @ul;

sub filetime {
    my ($filename)=@_;

    my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
        $atime,$mtime,$ctime,$blksize,$blocks)
        = stat($filename);

    return $ctime;
}

open(F, "<$latest");
my $la =<F>;
chomp $la;
close(F);

my $n;
if($n = $sul[0]) {
    if($n =~ /$pattern/) {
        my $stamp = $1;
        if($stamp ne $la) {
            # only if not the latest again
            $n =~ s/\.txt//;
            my $f = "$uploadpath/$n";
            my $when = filetime($f);
            printf "Uploaded: %s\n", $f;
            printf "Stamp: %s\n", $stamp;
            system "(mkdir -p $extract-$stamp && cd $extract-$stamp && unzip -oq $f)";
            system "echo $stamp > $latest";
            # update symlinks for "the latest"
            system "ln -sf dl-$stamp/curl-$stamp-win64-mingw.zip curl-win64-latest.zip";
            system "ln -sf dl-$stamp/curl-$stamp-win32-mingw.zip curl-win32-latest.zip";
            system "ln -sf dl-$stamp/curl-$stamp-win64-mingw.tar.xz curl-win64-latest.tar.xz";
            system "ln -sf dl-$stamp/curl-$stamp-win32-mingw.tar.xz curl-win32-latest.tar.xz";
        }
    }
}
