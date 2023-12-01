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

# symbols-in-versions
my $siv = $ARGV[0];

# sort by version
my $bynumber = $ARGV[1];

my $html = "manpage.html";
my $changelog = "/changes.html";

print "<table>\n";
print "<tr><th>Name</th>".
    "<th>Added</th>".
    "<th>Deprecated</th>".
    "<th>Last</th>".
    "</tr>\n";

sub vernum {
    my ($ver)= @_;
    my @a = split(/\./, $ver);
    return $a[0] * 10000 + $a[1] * 100 + $a[2];
}

sub verlink {
    my ($v)=@_;
    if($v && ($v ne "-")) {
        my $link = $v;
        $link =~ s/\./_/g;
        return "<a href=\"$changelog#$link\">$v</a>";
    }
    return "";
}

open(O, "<$siv");
while(<O>) {
    chomp;
    if($_ =~ /^(\S+) +([0-9.]+) *([^ ]*) *([0-9.]*)/) {
        my ($sym, $intro, $depr, $last) = ($1, $2, $3, $4);
        push @syms, $sym;
        $sintro{$sym}=$intro;
        $sdepr{$sym}=$depr;
        $slast{$sym}=$last;
    }
}
close(O);

my @sorted;
if($bynumber) {
    @sorted = reverse sort {vernum($sintro{$a}) <=> vernum($sintro{$b})} @syms;
}
else {
    # byname
    @sorted = sort @syms;
}

for my $s (@sorted) {
    printf "<tr><td>$s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n",
        verlink($sintro{$s}),
        verlink($sdepr{$s}),
        verlink($slast{$s});
}
print "</table>\n";
