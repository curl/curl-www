#!/usr/bin/perl
my @url;
my $prefix;
my @release;
while (<STDIN>) {
    my $l = $_;
    if( $_ =~ / \[(\d*)\] = (.*)/) {
        $url[$1] = $2;
    }
    else {
        push @release, $l;
    }
}

my $mode; # 0 - normal, 1 - known bugs, 2 - References
my $contr;

foreach my $l (@release) {
    if($mode == 1 ) {
        if($l =~ /^  ([^ \(].*)/) {
            $contr .= "$1 ";
        }
        elsif($l =~ /^References/) {
            $mode=2;
        }
    }
    elsif($mode == 2) {
        if( $l =~ / \[(\d*)\] = (.*)/) {
            $url[$1] = 2;
        }
    }
    elsif($l =~ /^Curl and libcurl (.*)/) {
        print "SUBTITLE(Fixed in $1 - [future])\n";
    }
    elsif($l =~ /^This release includes the following (.*):/) {
        if($prefix) {
            print "</ul>\n";
        }
        if($1 eq "known bugs") {
            $mode = 1;
            next;
        }
        if($1 eq "changes") {
            $prefix = "CHG";
        }
        else {
            $prefix = "BGF";
        }
        printf "<p> %s:\n<ul class=\"%s\">\n", ucfirst($1), $1;

    }
    else {
        chomp $l;
        if($l =~ / o (.*)\[(\d*)\]/) {
            my ($text, $num)=($1, $2);
            $text =~ s/ +$//;
            printf " $prefix <a href=\"%s\">%s</a>\n", $url[$num], $text;
        }
        elsif($l =~ / o (.*)/) {
            printf " $prefix %s\n", $1;
        }
    }
}

print "<p> Contributors:<p> $contr\n";
