#!/usr/bin/perl

$max = $ARGV[0];
$start = $ARGV[1];

if(!open(NEWS, "<news.html")) {
    print "<b>Failed to show news</b>";
    exit;
}

$inside=0;
$display=0;

if($max < 5) {
    $short=1;
}

while (<NEWS>) {
    if(!$inside) {
        if($_ =~ /<!-- start !-->/) {
            $startcount++;
            $inside = 1;
            if($startcount >= $start) {
                $display=1;
            }
        }
    }
    else {
        if($_ =~ /<!-- stop !-->/) {
            $inside=0;
            if($display) {
                $count++; # we count shown items only
                print $_;
            }
            if($count>=$max) {
                last;
            }
        }
    }
    if($inside && $display && $short) {
        $_ =~ s/colspan=1/colspan=2/g;
    }
    if($inside && $display) {    
        print $_;
    }
}
close(NEWS);
