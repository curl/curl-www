#!/usr/bin/perl

use HTML::Entities;

open(V, "<videolist.txt") || die;

# Only escape these minimal characters
sub enc {
    my $encoded = encode_entities(@_, '<>&"');
    return $encoded;
}

my %video;
sub onevideo {
    my $video = enc($video{"VIDEO"});
    my $url = enc($video{"URL"});
    my $thumb = $video{"THUMB"};
    my $size = $video{"THUMBSIZE"};
    my $duration = $video{"DURATION"};
    # This converts "5 minutes" or "1h3" into "PT5M" or "PT1HM"
    my $isoduration = "PT" . uc($duration);
    $isoduration =~ s/( minutes)?$/M/i;
    my $date = $video{"DATE"};
    my $s = enc($video{"SLIDES"});
    my $desc = enc($video{"DESC"});
    my $who = enc($video{"WHO"});
    my $tags = enc($video{"TAGS"});
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
        "<a itemprop=\"contentUrl\" href=\"$url\"> <img itemprop=\"thumbnailUrl\" alt=\"Thumbnail image of $video\" src=\"t/$thumb\" $size> </a><br>\n".
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
