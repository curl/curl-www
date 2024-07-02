#!/usr/bin/perl

require "./date.pm";

my $dir="download";
opendir(DIR, $dir) || die "cannot opendir $dir: $!";
my @files = readdir(DIR);
closedir DIR;
opendir(DIR, "$dir/archeology") || die "cannot opendir $dir/archeology: $!";
while (readdir DIR) {
   push @files, "archeology/$_";
}
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
    if($file =~ /([0-9.]*)\..*(zip|bz2|lzma|xz|gz)\z/) {
        my ($version, $ext)=($1, $2);
        $exts{$version}.="$ext,";
        $allext{$ext}++;
        $file{$version.$ext}=$file;
        $versions{$version}=1;
    }
}

open(HEAD, "<head.html");
while(<HEAD>) {
    $_ =~  s/<title>curl<\/title>/<title>curl downloads<\/title>\n<base href=\"https:\/\/curl.se\">/;
    print $_;
}
close(HEAD);

my $nice = TodayNicelyEng();

my $ae;
for(keys %allext) {
    $ae .= "$_ ";
}

print <<MOO
<div class="where"><a href="https://curl.se/">curl</a> / <b>download archive</b></div>
<h1>curl download archive</h1>

<div class="relatedbox">
<b>Related:</b>
<br><a href="https://curl.se/changes.html">Changelog</a>
<br><a href="https://curl.se/download.html">Download page</a>
<br><a href="https://curl.se/docs/releases.html">Release table</a>
</div>
<p>
<table class="daily" cellspacing="0" cellpadding="3">
<tr class="tabletop"><th>Version</th>
MOO
    ;
for(sort split(" ", $ae)) {
    print "<th>$_</th>\n";
}
print "</tr>\n";

sub num {
    my ($t)=@_;
    if($t =~ /^(\d)\.(\d+)\.(\d+)/) {
        return 10000*$1 + 100*$2 + $3;
    }
    elsif($t =~ /^(\d)\.(\d+)/) {
        return 10000*$1 + 100*$2;
    }
}


sub sortthem {
    return num($a) <=> num($b);
}

my $i;
for(reverse sort sortthem keys %versions) {
    my $date=$_;
    $finedate = $date;
    if($date =~ /(\d\d\d\d)(\d\d)(\d\d)/) {
        $finedate = sprintf("%s %d, %04d", MonthNameEng($2), $3, $1);
    }

    printf "<tr class=\"%s\"><td>$finedate</td> ",
    $i++&1?"odd":"even";
    for(sort split(" ", $ae)) {
        my $ext=$_;
        my $file = $file{$date.$ext};

        if($file && -f "$dir/$file" ) {
            printf "<td><a href=\"$dir/%s\">%.2fMB</a></td>",
                $file, filesize("$dir/$file")/(1024*1024);
        }
        else {
            print "<td>&nbsp;</td>\n";
        }
    }

    print "</tr>\n";
}
print "</table>\n";
print <<MOO
<p>


MOO
    ;

open(FOOT, "<foot.html");
print <FOOT>;
close(FOOT);
