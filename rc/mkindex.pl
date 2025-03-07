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
        $lookup{$file} = "$major-$minor-$patch-$rc-$ext";
        $sort{$file} = $major * 1000000 + $minor * 10000 + $patch * 100 + $rc;
        push @rc, $file;
    }
}

if($rc[0]) {

    print <<MOO
<table class="daily" cellspacing="0" cellpadding="8">
<tr class="tabletop">
<th>file</th>
<th>date</th>
<th>size</th>
<th>signature</th>
</tr>
MOO
        ;

    for my $f (sort { $sort {$a} <= $sort {$b}} @rc) {
        my $when = filetime("$f");
        my $d = strftime "%Y-%m-%d", gmtime($when);
        my $gpg;
        if(-e "$f.asc") {
            # a GPG signature
            $gpg="<a href=\"$f.asc\">GPG</a>";
        }
        my $fsize = filesize("$f");
        print "<tr>\n";
        printf "<td> <a href=\"$f\">$f</a> </td> <td>$d</td> <td>%.1f MB</td> <td> $gpg </td>\n",
            $fsize / (1024*1024);
        print "</tr>\n";
    }
    print "</table>\n";
}
else {
    print "<p>There are no available release candidates for the moment."
}
