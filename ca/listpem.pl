#!/usr/bin/perl

opendir(my $dh, ".") || die "can't opendir: $!";
my @pems = grep { /^cacert-.*pem/ } readdir($dh);
closedir $dh;

foreach my $p (reverse sort @pems) {
    if($p =~ /cacert-(.*).pem/) {
        print "<li> <a href=\"/ca/$p\">$1</a>\n";
    }
}
