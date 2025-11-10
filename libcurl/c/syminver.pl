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

# symbols-in-versions
my $siv = $ARGV[0];

# sort by version
my $bynumber = $ARGV[1];

my $html = "manpage.html";
my $changelog = "/ch/";

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
        if(-f "../../ch/$v.html") {
            return "<a href=\"$changelog$v.html\">$v</a>";
        }
        return "$v";
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

sub nameref {
    my ($n, $none)=@_;
    if($none) {
        return $n;
    }
    if($n =~ /^CURLOPT_/) {
        return "<a href=\"/libcurl/c/$n.html\">$n</a>";
    }
    elsif($n =~ /^CURLMOPT_/) {
        return "<a href=\"/libcurl/c/$n.html\">$n</a>";
    }
    elsif($n =~ /^CURLINFO_/) {
        return "<a href=\"/libcurl/c/$n.html\">$n</a>";
    }
    elsif($n =~ /^CURLALTSVC_/) {
        return "<a href=\"/libcurl/c/CURLOPT_ALTSVC_CTRL.html\">$n</a>";
    }
    elsif($n =~ /^CURLAUTH_/) {
        return "<a href=\"/libcurl/c/CURLOPT_HTTPAUTH.html\">$n</a>";
    }
    elsif($n =~ /^CURLFORM_/) {
        return "<a href=\"/libcurl/c/curl_formadd.html\">$n</a>";
    }
    elsif($n =~ /^CURLKH/) {
        return "<a href=\"/libcurl/c/CURLOPT_SSH_KEYFUNCTION.html\">$n</a>";
    }
    elsif($n =~ /^CURLE_/) {
        return "<a href=\"/libcurl/c/libcurl-errors.html\">$n</a>";
    }
    elsif($n =~ /^CURLM_/) {
        return "<a href=\"/libcurl/c/libcurl-errors.html\">$n</a>";
    }
    elsif($n =~ /^CURLUE_/) {
        return "<a href=\"/libcurl/c/libcurl-errors.html\">$n</a>";
    }
    elsif($n =~ /^CURLHE_/) {
        return "<a href=\"/libcurl/c/libcurl-errors.html\">$n</a>";
    }
    elsif($n =~ /^CURLSHE_/) {
        return "<a href=\"/libcurl/c/libcurl-errors.html\">$n</a>";
    }
    elsif($n =~ /^CURLPROTO_/) {
        return "<a href=\"/libcurl/c/CURLINFO_PROTOCOL.html\">$n</a>";
    }
    elsif($n =~ /^CURLPX_/) {
        return "<a href=\"/libcurl/c/CURLINFO_PROXY_ERROR.html\">$n</a>";
    }
    elsif($n =~ /^CURLPROXY_/) {
        return "<a href=\"/libcurl/c/CURLOPT_PROXYTYPE.html\">$n</a>";
    }
    elsif($n =~ /^CURLSSLBACKEND_/) {
        return "<a href=\"/libcurl/c/curl_global_sslset.html\">$n</a>";
    }
    elsif($n =~ /^CURLSSLOPT_/) {
        return "<a href=\"/libcurl/c/CURLOPT_SSL_OPTIONS.html\">$n</a>";
    }
    elsif($n =~ /^CURLSSLSET_/) {
        return "<a href=\"/libcurl/c/curl_global_sslset.html\">$n</a>";
    }
    elsif($n =~ /^CURLUPART_/) {
        return "<a href=\"/libcurl/c/curl_url_get.html\">$n</a>";
    }
    elsif($n =~ /^CURLU_/) {
        return "<a href=\"/libcurl/c/curl_url_get.html\">$n</a>";
    }
    elsif($n =~ /^CURLVERSION_/) {
        return "<a href=\"/libcurl/c/curl_version_info.html\">$n</a>";
    }
    elsif($n =~ /^CURLSHOPT_/) {
        return "<a href=\"/libcurl/c/$n.html\">$n</a>";
    }
    elsif($n =~ /^CURLWS_/) {
        return "<a href=\"/libcurl/c/curl_ws_send.html\">$n</a>";
    }
    elsif($n =~ /^CURL_FORMADD_/) {
        return "<a href=\"/libcurl/c/curl_formadd.html\">$n</a>";
    }
    elsif($n =~ /^CURL_HTTPPOST_/) {
        return "<a href=\"/libcurl/c/curl_formadd.html\">$n</a>";
    }
    elsif($n =~ /^CURL_GLOBAL_/) {
        return "<a href=\"/libcurl/c/curl_global_init.html\">$n</a>";
    }
    elsif($n =~ /^CURL_HTTP_VERSION_/) {
        return "<a href=\"/libcurl/c/CURLOPT_HTTP_VERSION.html\">$n</a>";
    }
    elsif($n =~ /^CURL_LOCK_/) {
        return "<a href=\"/libcurl/c/CURLSHOPT_SHARE.html\">$n</a>";
    }
    elsif($n =~ /^CURL_SSLVERSION_/) {
        return "<a href=\"/libcurl/c/CURLOPT_SSLVERSION.html\">$n</a>";
    }
    elsif($n =~ /^CURL_VERSION_/) {
        return "<a href=\"/libcurl/c/curl_version_info.html\">$n</a>";
    }
    elsif($n =~ /^CURL_RTSPREQ_/) {
        return "<a href=\"/libcurl/c/CURLOPT_RTSP_REQUEST.html\">$n</a>";
    }
    elsif($n =~ /^CURLH_/) {
        return "<a href=\"/libcurl/c/curl_easy_header.html\">$n</a>";
    }
    elsif($n =~ /^CURL_TRAILERFUNC_/) {
        return "<a href=\"/libcurl/c/CURLOPT_TRAILERFUNCTION.html\">$n</a>";
    }
    elsif($n =~ /^CURLOT_/) {
        return "<a href=\"/libcurl/c/curl_easy_option_next.html\">$n</a>";
    }
    elsif($n =~ /^CURLFINFOFLAG_/) {
        return "<a href=\"/libcurl/c/CURLOPT_CHUNK_BGN_FUNCTION.html\">$n</a>";
    }
    elsif($n =~ /^CURLFILETYPE_/) {
        return "<a href=\"/libcurl/c/CURLOPT_CHUNK_BGN_FUNCTION.html\">$n</a>";
    }
    elsif($n =~ /^CURL_CHUNK_BGN_FUNC_/) {
        return "<a href=\"/libcurl/c/CURLOPT_CHUNK_BGN_FUNCTION.html\">$n</a>";
    }
    elsif($n =~ /^CURL_CHUNK_END_FUNC_/) {
        return "<a href=\"/libcurl/c/CURLOPT_CHUNK_END_FUNCTION.html\">$n</a>";
    }
    elsif($n =~ /^CURLSSH_AUTH_/) {
        return "<a href=\"/libcurl/c/CURLOPT_SSH_AUTH_TYPES.html\">$n</a>";
    }
    elsif($n =~ /^CURL_POLL_/) {
        return "<a href=\"/libcurl/c/CURLMOPT_SOCKETFUNCTION.html\">$n</a>";
    }
    elsif($n =~ /^CURLMSG_/) {
        return "<a href=\"/libcurl/c/curl_multi_info_read.html\">$n</a>";
    }
    elsif($n =~ /^CURLFTPAUTH_/) {
        return "<a href=\"/libcurl/c/CURLOPT_FTPSSLAUTH.html\">$n</a>";
    }
    elsif($n =~ /^CURLFTPMETHOD_/) {
        return "<a href=\"/libcurl/c/CURLOPT_FTP_FILEMETHOD.html\">$n</a>";
    }
    elsif($n =~ /^CURLFTPSSL_/) {
        return "<a href=\"/libcurl/c/CURLOPT_USE_SSL.html\">$n</a>";
    }
    elsif($n =~ /^CURLFTP_CREATE_/) {
        return "<a href=\"/libcurl/c/CURLOPT_FTP_CREATE_MISSING_DIRS.html\">$n</a>";
    }
    elsif($n =~ /^CURLGSSAPI_DELEGATION_/) {
        return "<a href=\"/libcurl/c/CURLOPT_GSSAPI_DELEGATION.html\">$n</a>";
    }
    elsif($n =~ /^CURLHEADER_/) {
        return "<a href=\"/libcurl/c/CURLOPT_HEADEROPT.html\">$n</a>";
    }
    elsif($n =~ /^CURLHSTS_/) {
        return "<a href=\"/libcurl/c/CURLOPT_HSTS_CTRL.html\">$n</a>";
    }
    elsif($n =~ /^CURLIOCMD_/) {
        return "<a href=\"/libcurl/c/CURLOPT_IOCTLFUNCTION.html\">$n</a>";
    }
    elsif($n =~ /^CURLIOE_/) {
        return "<a href=\"/libcurl/c/CURLOPT_IOCTLFUNCTION.html\">$n</a>";
    }
    elsif($n =~ /^CURLMIMEOPT_/) {
        return "<a href=\"/libcurl/c/CURLOPT_MIME_OPTIONS.html\">$n</a>";
    }
    elsif($n =~ /^CURLPAUSE_/) {
        return "<a href=\"/libcurl/c/curl_easy_pause.html\">$n</a>";
    }
    elsif($n =~ /^CURLPIPE_/) {
        return "<a href=\"/libcurl/c/CURLMOPT_PIPELINING.html\">$n</a>";
    }
    elsif($n =~ /^CURLSOCKTYPE_/) {
        return "<a href=\"/libcurl/c/CURLOPT_SOCKOPTFUNCTION.html\">$n</a>";
    }
    elsif($n =~ /^CURLSTS_/) {
        return "<a href=\"/libcurl/c/CURLOPT_HSTSREADFUNCTION.html\">$n</a>";
    }
    elsif($n =~ /^CURLUSESSL_/) {
        return "<a href=\"/libcurl/c/CURLOPT_USE_SSL.html\">$n</a>";
    }
    elsif($n =~ /^CURL_CSELECT_/) {
        return "<a href=\"/libcurl/c/curl_multi_socket_action.html\">$n</a>";
    }
    elsif($n =~ /^CURL_FNMATCHFUNC_/) {
        return "<a href=\"/libcurl/c/CURLOPT_FNMATCH_FUNCTION.html\">$n</a>";
    }
    elsif($n =~ /^CURL_HET_/) {
        return "<a href=\"/libcurl/c/CURLOPT_HAPPY_EYEBALLS_TIMEOUT_MS.html\">$n</a>";
    }
    elsif($n =~ /^CURL_IPRESOLVE_/) {
        return "<a href=\"/libcurl/c/CURLOPT_IPRESOLVE.html\">$n</a>";
    }
    elsif($n =~ /^CURL_SEEKFUNC_/) {
        return "<a href=\"/libcurl/c/CURLOPT_SEEKFUNCTION.html\">$n</a>";
    }
    elsif($n =~ /^CURL_TIMECOND_/) {
        return "<a href=\"/libcurl/c/CURLOPT_TIMECONDITION.html\">$n</a>";
    }
    elsif($n =~ /^CURL_REDIR_POST_/) {
        return "<a href=\"/libcurl/c/CURLOPT_POSTREDIR.html\">$n</a>";
    }
    elsif($n =~ /^CURLMINFO_/) {
        return "<a href=\"/libcurl/c/curl_multi_get_offt.html\">$n</a>";
    }
    elsif($n =~ /^CURLMNOTIFY_/) {
        return "<a href=\"/libcurl/c/curl_multi_notify_enable.html\">$n</a>";
    }
    elsif($n =~ /^CURLMNWC_/) {
        return "<a href=\"/libcurl/c/curl_multi_setopt.html\">$n</a>";
    }
    elsif($n =~ /^CURLULFLAG_/) {
        return "<a href=\"/libcurl/c/CURLOPT_UPLOAD_FLAGS.html\">$n</a>";
    }
    elsif($n =~ /^CURLFOLLOW_/) {
        return "<a href=\"/libcurl/c/CURLOPT_FOLLOWLOCATION.html\">$n</a>";
    }
    return $n;
}

for my $s (@sorted) {
    printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n",
        nameref($s, $slast{$s}),
        verlink($sintro{$s}),
        verlink($sdepr{$s}),
        verlink($slast{$s});
}
print "</table>\n";
