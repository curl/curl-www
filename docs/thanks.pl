#!/usr/bin/perl

# This hash contains two or three digit prefixes that should be split in the
# output and use one additional letter.
my %cramped = ("al" => 1,
               "an" => 1,
               "ch" => 1,
               "da" => 1,
               "ja" => 1,
               "je" => 1,
               "jo" => 1,
               "ma" => 1,
               "mi" => 1,
               "pa" => 1,
               "ro" => 1,
               "st" => 1,
               "to" => 1,
               "mar" => 1,
               "dav" => 1,
               "and" => 1);
             
while(<STDIN>) {
    chomp;
    my $n=$_;

    # this matches A-z names
    if($n =~ /^([A-Za-z][A-Za-z. ])/i) {
        my $l=lc($1);

        if($cramped{$l}) {
            if($n =~ /^([A-Za-z][A-Za-z. ][A-Za-z.])/i) {
                $l=lc($1);
                if($cramped{$l}) {
                    if($n =~ /^([A-Za-z][A-Za-z. ][A-Za-z. ][A-Za-z.])/i) {
                        $l=lc($1);
                    }
                }
            }
        }
        
        $letter{$l} .= "$n, ";
    }
    elsif($n) {
        $letter{"rest"} .= "$n, ";
    }
}

# Output them all
for my $l (sort keys %letter) {
    printf "<a name=\"%s\"></a><h2>%s</h2>", $l, ucfirst($l);
    print $letter{$l}."\n";
}
print "<h2>Non A-Z names</h2>\n";
print $letter{"rest"};
