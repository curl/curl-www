#!/usr/local/bin/perl

require "../curl.pm";

require "/home/dast/perl/date.pm";

print "Content-Type: text/html\n\n";

&catfile("../head.html");

where(Docs, "/docs/", "Specs");

&title("Specifications that Concerns Curl");

my %desc;
open(DESC, "<filedesc");
while(<DESC>) {
    if($_ =~ /^([^ ]*) (.*)/) {
        $desc{$1}=$2;
    }
}
close(DESC);

print "<table>";
open(FILES, "ls -1t *.txt *.html 2>/dev/null|");
@files=<FILES>;
close(FILES);

sub sortfunc {
    my $A=$a;
    my $B=$b;
    $A =~ s/[a-zA-Z]//g;
    $B =~ s/[a-zA-Z]//g;

    return ($A <=> $B);
}

@sfiles = sort sortfunc @files;

print "<tr><th>File name</th>",
    "<th>Size</th>",
    "<th>Description</th>",
    "</tr>";
for(@sfiles) {
    chop;
    $filename = $_;

    $showname = $filename;

    $showname =~ s/\.[a-z]*$//g;

    ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
     $atime,$mtime,$ctime,$blksize,$blocks)
        = stat($filename);

    ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
        localtime($ctime);
    $mon++;
    $year+=1900;

    if($c++&1) {
        $col="bgcolor=\"#e0e0e0\"";
    }
    else {
        $col="";
    }

    $size = sprintf("%.1f", $size/1024);

    print "<tr $col><td><a href=\"$filename\">$showname</a></td>",
    "<td>$size&nbsp;Kb</td>",
    "<td>".$desc{$filename}."</td>\n",
    "</tr>\n";
}
print "</table>";
&catfile("../foot.html");
