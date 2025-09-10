#!/usr/bin/perl
use strict;

my $SSURL = "https://rest.opencollective.com/v2/curl/tier/silver-sponsor/orders/active";

## Silver sponsors

# URLs must match exactly the one retrieved from opencollective.com or if null the "slug"
my %silver = (
    "https://ipinfo.io/" => 'ipinfo.svg',
    "https://www.airbnb.com/" => 'airbnb.svg',
    "https://www.premium-minds.com" => 'premium-minds.svg',
    "https://www.partitionwizard.com" => 'partitionwizard-2.svg',
    "https://www.crosswordsolver.com" => 'CrosswordSolver.svg',
    "https://icons8.com/" => 'icons8.svg',
    "https://serpapi.com" => 'serpapi.svg',
    "https://proxy-hub.com/" => 'proxyhub.svg',
    'https://iboysoft.com' => 'iBoysoft.svg',
    "flutter-enterprises" => 'fineproxy.jpg',
    'https://onelessthing.co.uk/' => 'onelessthing.svg',
    'guest-b727d782' => 'zynk.svg',
    'babiel-gmbh' => 'babiel.svg',
    'https://www.iplocate.io' => 'iplocate.svg',

    # missing logo
    'king-johnnie1' => '[none]', # no logo provided

    # Sponsors that don't get images
    'https://www.jackpotjill.ai/en/' => '[none]', # gambling
    'https://www.stellarspins.fun/en/' => '[none]', # gambling
    'https://www.wolfwinner.fun/en' => '[none]', # gambling
    'https://au.crazyvegas.com/' => '[none]', # gambling
    'thebestsolution' => '[none]',  # link denied 16 May 2024 due to social media manipulation
    'https://stellarlikes.com' => '[none]', # social media manipulation
    );

# URLs that are changed from the one in the profile
my %modurl = (
    'flutter-enterprises' => 'https://fineproxy.org/',
    'guest-b727d782' => 'https://zynk.it',
    'babiel-gmbh' => 'https://www.babiel.com/',
    );

# Get the list of Silver Sponsor URLs
# Some users don't have web sites configured, in which case use the username
# instead and map it to a URL with %modurl
open(S, "curl -sRL --compressed --proto -all,+https --max-redirs 3 --max-time 10 $SSURL | jq '.nodes[] | if (.fromAccount.website == null) then .fromAccount.slug else .fromAccount.website end'|");
my @urls=<S>;
close(S);

my %found;
my $images;
my $count;
for my $u (reverse @urls) {
    {
        my $url = $u;
        $url =~ s/[\"\n]//g;
        my $img = $silver{$url};

        if(!$img) {
            print STDERR "\n*** Missing image: for $url ($img)\n";
        }
        $found{$url}=1;
        if($img ne '[none]') {
            my $alt = $img;
            my $href = $url;
            $alt =~ s/(.*)\....$/$1/;  # strip the extension
            $alt =~ s/^([-a-z0-9]*)$/\u$1/;  # capitalize only if all lowercase
            if($modurl{$url}) {
                $href=$modurl{$url};
                $found{$href}=1;
            }
            print <<SPONSOR
<div class="silver"><p> <a class="x" href="$href" rel="sponsored"><img src="pix/silver/$img" alt="$alt"></a></div>
SPONSOR
                ;
            if(! -f "pix/silver/$img") {
                print STDERR "Missing image file: pix/silver/$img\n";
                exit 1;
            }
            $images++;
        }
        $count++;
    }
}

my $sec;
open(SP, "<_sponsors.html");
while(<SP>) {
    if($_ =~ /^<div class="silver"><p> <a class=\"x\" href="([^"]*)/) {
        my $exist=$1;
        if(!$found{$exist}) {
            print STDERR "$exist is not a sponsor anymore\n";
        }
        $sec++;
    }
}
close(SP);

if($sec != $images) {
    print STDERR "_sponsors.html count ($sec) does not match online count: $count ($images with images)\n";
}


print STDERR "$count sponsors, $images images\n";
