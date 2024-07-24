#!/usr/bin/perl
#***************************************************************************
#                                  _   _ ____  _
#  Project                     ___| | | |  _ \| |
#                             / __| | | | |_) | |
#                            | (__| |_| |  _ <| |___
#                             \___|\___/|_| \_\_____|
#
# Copyright (C) Daniel Stenberg, <daniel@haxx.se>, et al.
#
# This software is licensed as described in the file COPYING, which
# you should have received as part of this distribution. The terms
# are also available at https://curl.se/docs/copyright.html.
#
# You may opt to use, copy, modify, merge, publish, distribute and/or sell
# copies of the Software, and permit persons to whom the Software is
# furnished to do so, under the terms of the COPYING file.
#
# This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
# KIND, either express or implied.
#
# SPDX-License-Identifier: curl
#
###########################################################################

# options-in-versions
my $oinv = $ARGV[0];

my $html = "manpage.html";
my $changelog = "/ch/";

my %vers;
open(O, "<$oinv");
while(<O>) {
    if($_ =~ /^(\S+) (\((.*)\)|) +([0-9.]+)/) {
        my ($long, $sh, $version) = ($1, $3, $4);
        $vers{$version} = 1;
        $added{$version} .= "$long ";
        $short{$long}=$sh;
    }
}

sub vernum {
    my ($ver)= @_;
    my @a = split(/\./, $ver);
    return $a[0] * 10000 + $a[1] * 100 + $a[2];
}

sub verlink {
    my ($ver)= @_;
    if(-f "../ch/$ver.html") {
        return "<a href=\"$changelog$ver.html\">$ver</a>";
    }
    return "$ver";
}

print "<table>\n";
for my $v (sort {vernum($b) <=> vernum($a) } keys %vers) {
    printf "<tr><td valign=\"top\">%s</td><td>\n", verlink($v);
    for my $l (split(/ /, $added{$v})) {
        printf "<a href=\"%s#%s\">$l%s</a><br>\n",
            $html, $short{$l}?"$short{$l}":$l,
            $short{$l}?" ($short{$l})":"";
    }
    print "</td></tr>\n";
}
print "</table>\n";
