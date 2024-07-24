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
        $added{$long} = $version;
        $short{$long} = $sh;
    }
}

sub verlink {
    my ($ver)= @_;
    return "$ver.html";
}

sub manlink {
    my ($long)= @_;
    if($short{$long}) {
        return $short{$long};
    }
    return $long;
}

print "<table>\n";
for my $long (sort {lc($a) cmp lc($b) } keys %short) {
    my $v = $added{$long};
    printf "<tr><td><a href=\"manpage.html#%s\">$long</a></td><td><a href=\"%s%s\">$v</a></td></tr>\n",
        manlink($long),
        $changelog, verlink($v);
}
print "</table>\n";
