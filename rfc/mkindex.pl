#!/usr/bin/perl

require "../curl.pm";
require "/home/dast/perl/date.pm";

my %desc;
open(DESC, "<filedesc");
while(<DESC>) {
    if($_ =~ /^([^ ]*) (.*)/) {
        $desc{$1}=$2;
    }
}
close(DESC);

my $some_dir=".";
opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
my @files = grep { /\.(txt|html)/ && -f "$some_dir/$_" } readdir(DIR);
closedir DIR;


print "<table>";

print "<tr class=\"tabletop\"><th>File name</th>",
    "<th>Size</th>",
    "<th>Description</th>",
    "</tr>";
for(sort @files) {
    $filename = $_;

    if($filename =~ /index/) {
        next;
    }

    $showname = $filename;

    $showname =~ s/\.[a-z]*$//g;

    my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
     $atime,$mtime,$ctime,$blksize,$blocks)
        = stat($filename);

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
        localtime($ctime);
    $mon++;
    $year+=1900;

    if($c++&1) {
        $col="odd";
    }
    else {
        $col="even";
    }

    $size = sprintf("%.1f", $size/1024);

    print "<tr class=\"$col\"><td><a href=\"/rfc/$filename\">$showname</a></td>",
    "<td>$size&nbsp;Kb</td>",
    "<td>".$desc{$filename}."</td>\n",
    "</tr>\n";
}
print "</table>";

