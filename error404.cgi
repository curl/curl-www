#!/usr/local/bin/perl

print "Content-Type: text/html\n\n";

require "curl.pm";

$file=$ENV{'REQUEST_URI'};
$referer=$ENV{'HTTP_REFERER'};

&catfile("head.html");

&title("Oops! This document does not seem to exist!");

print "<p>The document <b>$file</b> (that you requested) doesn't exist here.",
    " It may have existed here earlier and",
    " is now removed, or it may never have existed.\n";

if($file =~ /(rpm|zip|gz|bz2)$/) {
    print "<p><big>Judging from the file name you tried to get, it is an archive.",
    " Try finding a newer one from the <a href=\"/download.html\">",
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
    " need, or step right into the <a href=\"/search.html\">search page</a>.";

&catfile("foot.html");
print "</body></html>\n";

