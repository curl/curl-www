#!/usr/bin/env perl

# -h1
# - h2

my $h1;
my $h2;

while(<STDIN>) {
    if(/^<h1 id=\"([^"]*)\">([^<]*)/) {
        print "</ol>\n";
        $h2 = 0;
        $h1++;
        if($h1 > 1) {
            # skip the intro title
            print "<h2><a href=\"\#$1\">$2\</a></h2><ol>\n";
        }
    }
    elsif(/^<h2 id=\"([^"]*)\">(.*)<\/h2>/) {
        my ($link, $text)=($1, $2);
        $h2++;
        $text =~ s/<code>//g;
        $text =~ s/<\/code>//g;
        $text =~ s/\*/\&#42;/g;
        print "<li> <a href=\"\#$link\">$text</a>\n";
    }
}
if($h2) {
    print "</ol>\n";
}
