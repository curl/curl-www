#!/usr/bin/perl

## Silver sponsors

my %silver = (
    "https://streamat.se" => 'streamat.jpg',
    "https://nysportsjournal.com" => 'NYSJ.png',
    "https://followerspromotion.com/" => 'FPlogo.png',
    "https://buy.fineproxy.org/eng/" => 'fineproxy.png',
    "https://www.rabattkalas.se" => 'rabattkalas.png',
    "https://unscramblex.com/" => 'Unscramblex-black.png',
    "https://www.romab.com" => '', # none
    "https://www.premium-minds.com" => 'premium-minds.png',
    "https://www.partitionwizard.com" => 'partitionwizard.jpg',
    "https://www.crosswordsolver.com" => 'CrosswordSolver.png',
    "https://www.minitool.com" => 'minitool.png',
    "https://www.maid2clean.co.uk/domestic-cleaning/" => 'maid2clean.png',
    "https://icons8.com" => 'icons8.png'
    );

# the URLs
open(S, "curl https://rest.opencollective.com/v2/curl/tier/silver-sponsor/orders/active -s | jq '.nodes[].fromAccount.website'|");
@urls=<S>;
close(S);

for my $u (reverse @urls) {
    if($u =~ /\"(.*)\"/) {
        my $url = $1;
        my $img = $silver{$url};

        if($img) {
            my $alt = $img;
            $alt =~ s/(.*)\..../$1/;
            print <<SPONSOR
<div class="silver"><p> <a href="$url" rel="sponsored"><img src="pix/silver/$img" alt="$alt"></a></div>
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

print STDERR "$count sponsors, $images images\n";
