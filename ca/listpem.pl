#!/usr/bin/perl

opendir(my $dh, ".") || die "can't opendir: $!";
my @pems = grep { /^cacert-.*pem/ } readdir($dh);
closedir $dh;

sub countcerts {
    my ($f)=@_;
    open(F, "<$f");
    my $cert;
    while(<F>) {
        if($_ =~ /^-----BEGIN/) {
            $cert++;
        }
    }
    return $cert;
}

print "<table><tr><th>Date</th><th>Certificates</th><tr>\n";
my $l = 0;
foreach my $p (reverse sort @pems) {
    if($p =~ /cacert-(.*).pem/) {
        my $n = countcerts($p);
        my $date = $1;
        printf "<tr %s><td><a href=\"/ca/$p\">%s</a></td> <td align=center>%d</td></tr>\n",
            $l&1?"class=\"odd\"":"",
            $date, $n;
        if(++$l >= 10) {
            # only show 10
            last;
        }
    }
}
print "</table>\n";
