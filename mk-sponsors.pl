#!/usr/bin/perl

# https://rest.opencollective.com/v2/curl/tier/silver-sponsor/orders/active

## Silver sponsors

# URLs must match exactly the one retrieved from opencollective.com
my %silver = (
    "https://ipinfo.io/" => 'ipinfo.svg',
    "https://unscramblex.com/" => 'unscramblex.svg',
    "https://www.romab.com" => '[none]',
    "https://www.airbnb.com/" => 'airbnb.svg',
    "https://www.premium-minds.com" => 'premium-minds.svg',
    "https://www.partitionwizard.com" => 'partitionwizard-2.svg',
    "https://www.crosswordsolver.com" => 'CrosswordSolver.svg',
    "https://www.minitool.com" => 'minitool-2.svg',
    "https://www.maid2clean.co.uk/domestic-cleaning/" => 'maid2clean.svg',
    "https://icons8.com" => 'icons8.svg',
    "https://serpapi.com" => 'serpapi.svg',
    'https://hightouch.io/' => 'hightouch.svg',
    'https://mowcapital.com' => 'mowcapital.svg',
    "https://proxy-hub.com/" => 'proxyhub.svg',
    'https://cryptotracker.com' => 'crypto-tracker.svg',
    'https://www.sure.bet/casinos-not-on-gamstop/' => 'surebet.png',
    'https://iboysoft.com' => 'iBoysoft.png',
    );
my %modurl = (
    );

# the URLs
open(S, "curl https://rest.opencollective.com/v2/curl/tier/silver-sponsor/orders/active -s | jq '.nodes[].fromAccount.website'|");
@urls=<S>;
close(S);

for my $u (reverse @urls) {
    if($u =~ /\"(.*)\"/) {
        my $url = $1;
        my $img = $silver{$url};

        if(!$img) {
            print STDERR "\n*** Missing image: for $url\n";
        }
        $found{$url}=1;
        if($img ne '[none]') {
            my $alt = $img;
            my $href = $url;
            $alt =~ s/(.*)\..../$1/;
            if($modurl{$url}) {
                $href=$modurl{$url};
                $found{$href}=1;
            }
            print <<SPONSOR
<div class="silver"><p> <a class="x" href="$href" rel="sponsored"><img src="pix/silver/$img" alt="$alt"></a></div>
SPONSOR
                ;
            if(! -f "pix/silver/$img") {
                print STDERR "Missing image: $img\n";
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
    print STDERR "_sponsors.html count ($sec) doesn't match online count: $count ($images with images)\n";
}


print STDERR "$count sponsors, $images images\n";
