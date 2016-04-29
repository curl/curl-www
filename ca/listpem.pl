#!/usr/bin/perl

opendir(my $dh, ".") || die "can't opendir: $!";
my @pems = grep { /^cacert-.*pem/ } readdir($dh);
closedir $dh;

foreach my $p (reverse sort @pems) {
    print "<li> <a href=\"$p\">$p</a>\n";
}
