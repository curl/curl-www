#!/usr/bin/perl

#use Time::localtime;
use POSIX qw(strftime);

my $dir=".";
opendir(DIR, $dir) || die "can't opendir $dir: $!";
my @files = readdir(DIR);
closedir DIR;

sub filesize {
    my ($filename)=@_;

    my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
        $atime,$mtime,$ctime,$blksize,$blocks)
        = stat($filename);

    return $size;
}

sub filetime {
    my ($filename)=@_;

    my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
        $atime,$mtime,$ctime,$blksize,$blocks)
        = stat($filename);

    return $mtime;
}

for(@files) {
    my $file = $_;
    if($file =~ /^curl-(\d+)\.(\d+)\.(\d+)-rc([0-9])\.(tar.gz|tar.bz2|tar.xz|zip)\z/) {
        my ($major, $minor, $patch, $rc, $ext)=($1, $2, $3, $4, $5);
        $sort{$file} = $major * 1000000 + $minor * 10000 + $patch * 100 + $rc;
        push @rc, $file;

        # track each rc available
        $filever{$file} = "$major.$minor.$patch-rc$rc";
    }
}

if($rc[0]) {
    my $oldver = "nada";

    print <<MOO
<table class="daily" cellspacing="0" cellpadding="8">
MOO
        ;

    for my $f (sort { $sort {$b} <=> $sort {$a}} @rc) {
        my $when = filetime("$f");
        my $d = strftime "%Y-%m-%d", gmtime($when);
        my $pgp;
        if(-e "$f.asc") {
            # a PGP signature
            $pgp="<a href=\"$f.asc\">PGP</a>";
        }
        my $fsize = filesize("$f");

        if($oldver ne $filever{$f} ) {
            $oldver = $filever{$f};
            my $commit;
            if(-e "curl-$oldver.commit") {
                # commit hhash
                open(H, "<curl-$oldver.commit");
                my @ha = <H>;
                close(H);
                my $hash = join(//, @ha);
                $commit=" (<a href=\"https://github.com/curl/curl/commit/$hash\">commit</a>)";
            }
            print "<tr><td colspan=4><b> $oldver </b>$commit</td></tr>\n";
        }
        print "<tr>\n";
        printf "<td> <a href=\"$f\">$f</a> </td> <td>$d</td> <td>%.1f MB</td> <td> $pgp </td>\n",
            $fsize / (1024*1024);
        print "</tr>\n";
    }
    print "</table>\n";

}
else {
    print "<p>There are no available release candidates for the moment."
}
