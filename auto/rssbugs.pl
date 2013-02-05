#!/usr/bin/perl

use LWP::Simple;
use XML::RSS;

my $url="https://sourceforge.net/p/curl/bugs/search_feed/?q=%21status%3Aclosed-wont-fix+%26%26+%21status%3Aclosed-later+%26%26+%21status%3Aclosed-accepted+%26%26+%21status%3Aclosed-duplicate+%26%26+%21status%3Aclosed-out-of-date+%26%26+%21status%3Aclosed-postponed+%26%26+%21status%3Aclosed-rejected+%26%26+%21status%3Aclosed-remind+%26%26+%21status%3Aclosed-works-for-me+%26%26+%21status%3Aclosed+%26%26+%21status%3Aclosed-invalid+%26%26+%21status%3Aclosed-fixed&limit=225";

binmode(STDOUT, ":utf8");

my $rss = XML::RSS->new();
my $data = get( $url );
$rss->parse( $data );

#my $channel = $rss->{channel};
#my $title   = $channel->{title};
#my $link    = $channel->{link};
#my $desc    = $channel->{description};

my @out;
my $bugs;

push @out, "<table>\n";
foreach my $item ( @{ $rss->{items} } )
{
    my $link  = $item->{link};
    my $title = $item->{title};

    my $num=0;
    if($link =~ /bugs\/(\d+)/) {
        $num = $1;
    }
  
    push @out, sprintf "<tr><td>#%d</td><td><a href=\"%s\"> %s</a></td></tr>\n", $num, $link, $title;
    $bugs++; 
}
push @out, "</table>\n";

if(!$bugs) {
    print "No bugs found!\n";
}
else {
    print @out;
}
