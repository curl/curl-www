#!/usr/bin/env perl

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

for(@files) {
    my $file = $_;
    if($file =~ /^curl-([0-9.]*)-([0-9]*)\.(.*)/) {
        my ($version, $date, $ext)=($1, $2, $3);
        $dates{$date}=$date;
        $exts{$date}.="$ext,";
        $allext{$ext}++;
        $file{$date.$ext}=$file;
        $version{$date}=$version;
    }
}

my $ae;
for(keys %allext) {
    $ae .= "$_ ";
}

print <<MOO
<table class="daily" cellspacing="0" cellpadding="3">
<tr class="tabletop"><th>date</th>
MOO
    ;
for(sort split(" ", $ae)) {
    print "<th>$_</th>\n";
}
print "</tr>\n";

my $i;
for(reverse sort keys %dates) {
    my $date=$_;
    $finedate = $date;
    if($date =~ /(\d\d\d\d)(\d\d)(\d\d)/) {
        $finedate = sprintf("%04d-%02d-%02d", $1, $2, $3);
    }

    printf "<tr class=\"%s\"><td>$finedate</td> ",
    $i++&1?"odd":"even";
    for(sort split(" ", $ae)) {
        my $ext=$_;
        my $file = $file{$date.$ext};

        if(-f "$dir/$file" ) {
            if(!$bestfile{$ext}) {
                print "<!--\n",
                "NEWEST ${ext} $file\n",
                "-->\n";
                $bestfile{$ext}=1;
            }


            printf "<td><a href=\"${url}%s\">%.2fMB</a></td>",
            $file, filesize("$dir/$file")/(1024*1024);
        }
        else {
            print "<td>&nbsp;</td>\n";
        }
    }

    print "</tr>\n";
}
print "</table>\n";
