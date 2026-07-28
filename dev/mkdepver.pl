#!/usr/bin/env perl
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

my $mode = 0;
my $i = 0;

while(<STDIN>) {
    if(/^## Dependencies/) {
        # the subtitle for run-time dependencies
        print "<h2>Run-time dependencies</h2>\n";
        print "<table>\n";
        print "<tr><th>library</th><th>version</th><th>release date</th>\n";
        $mode = 1;
    }
    elsif(/^## Build tools/) {
        print "</table>\n";
        print "<h2>Build dependencies</h2>\n";
        print "<table>\n";
        print "<tr><th>tool</th><th>version</th><th>release date</th>\n";
        $mode = 2;
        $i = 0;
    }
    elsif(/^## Testing/) {
        print "</table>\n";
        print "<h2>Test dependencies</h2>\n";
        print "<table>\n";
        print "<tr><th>tool</th><th>version</th><th>release date</th>\n";
        $mode = 3;
        $i = 0;
    }
    elsif(/^##/) {
        $mode = 0;
    }

    if(/^ *- (.*)  ([^(]*)(.*)/ && $mode) {
        my ($what, $ver, $date) = ($1, $2, $3);
        $what =~ s/ +$//;
        $ver =~ s/ +$//;
        $date =~ s/^\(//; # remove a leading open paren
        $date =~ s/\)//; # remove the first close paren
        printf "<tr class=\"%s\"><td>$what</td><td>$ver</td><td>$date</td>\n",
            $i & 1 ? "odd" : "even";
        $i++;
    }
}
print "</table>\n";

