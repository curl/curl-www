#!/usr/bin/perl

# rename them all first
for(@ARGV) {
    $file = $_;

    $newfile = $file;
    $newfile =~ s/\.t/.html/g;
    rename($file, $newfile);

    $all .= "$newfile ";
}

# tar them all to one archive:
system("tar -cf curl-html-docs.tar $all");

# gzip it
system("gzip curl-html-docs.tar");

# get time
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);

$year += 1900;
$mon += 1;

$date = sprintf("%04d%02d%02d", $year, $mon, $mday);

# remove older archives:
system("rm curl-html-docs-*.tar.gz");

# make a copy with the current time/date 
system("cp curl-html-docs.tar.gz curl-html-docs-$date.tar.gz");
