#!/usr/bin/perl
# Copyright (C) Daniel Stenberg, <daniel@haxx.se>, et al.
#
# SPDX-License-Identifier: curl
#
# Input: a markdown file
# Output: modifies the markdown file to fit spellchecking jobs
#

my $f = $ARGV[0];
my $o = "$f.tmp";

open(F, "<$f") or die;
open(O, ">$o") or die;

my $ignore = 0;
while(<F>) {
    # filter out mentioned CURLE_ names
    $_ =~ s/CURL(M|SH|U|H)code//g;
    $_ =~ s/CURL_(READ|WRITE)FUNC_[A-Z0-9_]*//g;
    $_ =~ s/CURL_CSELECT_[A-Z0-9_]*//g;
    $_ =~ s/CURL_DISABLE_[A-Z0-9_]*//g;
    $_ =~ s/CURL_FORMADD_[A-Z0-9_]*//g;
    $_ =~ s/CURL_HET_DEFAULT//g;
    $_ =~ s/CURL_IPRESOLVE_[A-Z0-9_]*//g;
    $_ =~ s/CURL_PROGRESSFUNC_CONTINUE//g;
    $_ =~ s/CURL_REDIR_[A-Z0-9_]*//g;
    $_ =~ s/CURL_RTSPREQ_[A-Z0-9_]*//g;
    $_ =~ s/CURL_TIMECOND_[A-Z0-9_]*//g;
    $_ =~ s/CURL_VERSION_[A-Z0-9_]*//g;
    $_ =~ s/CURLALTSVC_[A-Z0-9_]*//g;
    $_ =~ s/CURLAUTH_[A-Z0-9_]*//g;
    $_ =~ s/CURLE_[A-Z0-9_]*//g;
    $_ =~ s/CURLFORM_[A-Z0-9_]*//g;
    $_ =~ s/CURLFTP_[A-Z0-9_]*//g;
    $_ =~ s/CURLFTPAUTH_[A-Z0-9_]*//g;
    $_ =~ s/CURLFTPMETHOD_[A-Z0-9_]*//g;
    $_ =~ s/CURLFTPSSL_[A-Z0-9_]*//g;
    $_ =~ s/CURLGSSAPI_[A-Z0-9_]*//g;
    $_ =~ s/CURLHEADER_[A-Z0-9_]*//g;
    $_ =~ s/CURLINFO_[A-Z0-9_]*//g;
    $_ =~ s/CURLM_[A-Z0-9_]*//g;
    $_ =~ s/CURLMIMEOPT_[A-Z0-9_]*//g;
    $_ =~ s/CURLMOPT_[A-Z0-9_]*//g;
    $_ =~ s/CURLOPT_[A-Z0-9_]*//g;
    $_ =~ s/CURLPIPE_[A-Z0-9_]*//g;
    $_ =~ s/CURLPROTO_[A-Z0-9_]*//g;
    $_ =~ s/CURLPROXY_[A-Z0-9_]*//g;
    $_ =~ s/CURLPX_[A-Z0-9_]*//g;
    $_ =~ s/CURLSHE_[A-Z0-9_]*//g;
    $_ =~ s/CURLSHOPT_[A-Z0-9_]*//g;
    $_ =~ s/CURLSSH_[A-Z0-9_]*//g;
        $_ =~ s/CURLSSLBACKEND_[A-Z0-9_]*//g;
    $_ =~ s/CURLU_[A-Z0-9_]*//g;
    $_ =~ s/CURLUE_[A-Z0-9_]*//g;
    $_ =~ s/CURLUPART_[A-Z0-9_]*//g;
    $_ =~ s/CURLUSESSL_[A-Z0-9_]*//g;
    $_ =~ s/curl_global_(init_mem|sslset|cleanup)//g;
    $_ =~ s/curl_(strequal|strnequal|formadd|waitfd|formget|getdate|formfree)//g;
    $_ =~ s/curl_easy_(nextheader|duphandle)//g;
    $_ =~ s/curl_multi_fdset//g;
    $_ =~ s/curl_mime_(subparts|addpart|filedata|data_cb)//g;
    $_ =~ s/curl_ws_(send|recv|meta)//g;
    $_ =~ s/curl_url_(dup)//g;
    $_ =~ s/libcurl-env//g;
    $_ =~ s/(^|\W)((tftp|https|http|ftp):\/\/[a-z0-9\-._~%:\/?\#\[\]\@!\$&'()*+,;=]+)//gi;
    $_ =~ s/^- Reported-by:.*//;
    $_ =~ s/^- Patched-by:.*//;
    $_ =~ s/^- Help-by:.*//;
    $_ =~ s/(`[^`]*`)//g;
    print O $_;
}
close(F);
close(O);

rename($o, $f);
