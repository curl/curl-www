#!/usr/local/bin/perl

print "Content-Type: text/html\n\n";

require "curl.pm";

$file=$ENV{'REQUEST_URI'};
$referer=$ENV{'HTTP_REFERER'};

print "<html><head><title>Curl: Document doesn't exist</title></head><body bgcolor=\"#ffffff\">\n",
    "<a href=\"http://curl.haxx.se/\"><img border=0 src=\"http://curl.haxx.se/small-curl.png\" width=90 height=36 alt=\"Curl\"></a>";

&title("Ooops! This document does not seem to exist!");

print "<p>The document <b>$file</b> doesn't exist here.",
    " It may have existed here earlier and",
    " is now removed, or it may never have existed.\n";

if($file =~ /(rpm|zip|gz|bz2)$/) {
    print "<p><big>Judging from the file name you tried to get, it is an archive.",
    " Try one from the <a href=\"/download.html\">",
    "download page</a>.</big>\n";
}

if(($referer ne "") && ($referer !~ /curl.haxx/)) {
    print "<p> It would be polite of you to contact the admins of <a href=",
    "\"$referer\">$referer</a> and inform them about this problem.\n";
}

print "<p> Sometimes search engines keep very old information that might have",
    " lead you here or sometimes we just had to rearrange pages or remove",
    " deprecated information.";

print "<p> Continue to <a href=\"/\">curl.haxx.se</a> to find the information you",
    " need, or step right into the <a href=\"/htdig/\">search page</a>.";

print "<p align=right><small> <a ",
"href=\"mailto:curl-web_at_haxx.se\">webmaster</a></small>\n",
    "</body></html>\n";

