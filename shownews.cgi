#!/usr/bin/perl

$max = $ARGV[0];
$start = $ARGV[1];

if(!open(NEWS, "<newslog.html")) {
    print "<b>Failed to show news</b>";
    exit;
}

$inside=0;
$display=0;

if($max < 5) {
    $short=1;
}

while (<NEWS>) {
    my $l = $_;
    if(!$inside) {
        if($l =~ s/<!-- start !-->//) {
            $startcount++;
            $inside = 1;
            if($startcount >= $start) {
                $display=1;
            }
        }
    }
    else {
        if($l =~ s/<!-- stop !-->//) {
            $inside=0;
            if($display) {
                $count++; # we count shown items only
                print $l;
            }
            if($count>=$max) {
                last;
            }
        }
    }
    if($inside && $display) {
        print $l;
    }
}
close(NEWS);
