#!/usr/bin/perl

open(V, "<videolist.txt") || die;

my %video;
sub onevideo {
    my $video = $video{"VIDEO"};
    my $url = $video{"URL"};
    my $thumb = $video{"THUMB"};
    my $size = $video{"THUMBSIZE"};
    my $duration = $video{"DURATION"};
    my $date = $video{"DATE"};
    my $s = $video{"SLIDES"};
    my $desc = $video{"DESC"};
    my $who = $video{"WHO"};
    my $slides;
    if($s) {
        $slides = " [<a href=\"$s\">slides</a>]";
    }
    print <<STOP
<div class="video"> <a href="$url"> <img src="t/$thumb" $size> </a> <br>
  <b>$video</b> <p> $duration, $date$slides <p> $desc by $who </div>
STOP
        ;

}

while(<V>) {
    my $l=$_;
    chomp $l;
    if($l =~ /^([^ ]+) (.*)/) {
        my ($name, $val)=($1, $2);
        $video{$name}=$val;
    }
    elsif($l eq "ENDOFVIDEO") {
        if($video{"VIDEO"}) {
            onevideo();
        }
        undef %video;
    }
}
