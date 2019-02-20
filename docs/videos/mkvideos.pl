#!/usr/bin/perl

open(V, "<videolist.txt") || die;

my %video;
sub onevideo {
    my $video = $video{"VIDEO"};
    my $url = $video{"URL"};
    my $thumb = $video{"THUMB"};
    my $size = $video{"THUMBSIZE"};
    my $duration = $video{"DURATION"};
    # This converts "5 minutes" or "1h3" into "PT5M" or "PT1HM"
    my $isoduration = "PT" . uc($duration);
    $isoduration =~ s/( minutes)?$/M/i;
    my $date = $video{"DATE"};
    my $s = $video{"SLIDES"};
    my $desc = $video{"DESC"};
    my $who = $video{"WHO"};
    my $tags = $video{"TAGS"};
    my $keywords = "<meta itemprop=\"keywords\" content=\"curl, $tags\" />" if $tags;
    my $slides;
    my $e = $video{"EVENT"};
    my $event;
    if($s) {
        $slides = " [<a href=\"$s\">slides</a>]";
    }
    if($e) {
        $event = sprintf(" at %s", $e);
    }
    return "<!-- $date -->".
        "<div itemprop=\"video\" itemscope itemtype=\"http://schema.org/VideoObject\"><div class=\"video\">\n".
        "<meta itemprop=\"contentUrl\" content=\"$url\" /><a href=\"$url\"> <img alt=\"Thumbnail image of $video\" src=\"t/$thumb\" $size> </a>\n".
        "<meta itemprop=\"thumbnailUrl\" content=\"https://curl.haxx.se/docs/videos/t/$thumb\" /><br>\n".
        "<b><span itemprop=\"name\">$video</span></b> <p> <meta itemprop=\"duration\" content=\"$isoduration\" />$duration, <span itemprop=\"dateCreated uploadDate\">$date</span>$slides <p>\n".
        "<span itemprop=\"description\">$desc by <span itemprop=\"actor\">$who</span>$event</span>$keywords</div>".
        "</div>";
}

my @o;
while(<V>) {
    my $l=$_;
    chomp $l;
    if($l =~ /^([^ ]+) (.*)/) {
        my ($name, $val)=($1, $2);
        $video{$name}=$val;
    }
    elsif($l eq "ENDOFVIDEO") {
        if($video{"VIDEO"}) {
            push @o, onevideo();
        }
        undef %video;
    }
}
for (reverse sort @o) {
    print "$_\n";
}
