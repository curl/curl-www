#!/usr/bin/perl

require "CGI.pm";
require "pbase.pm";
require "date.pm";

use feedback;

$req = new CGI;

$permit = $req->param('passwd');
$remark = $req->param('remark');
$id = $req->param('id');

$remarkdate = sprintf("%04d-%02d-%02d", &ThisYear, &ThisMonth, &ThisDay);

# convert < and > first
$remark =~ s/</&lt;/g;
$remark =~ s/>/&gt;/g;

# insert <p> to make new paragraphs
$remark =~ s/\r\n\r\n/\r\n<p>\r\n/g;

# replace http://-specified URLs
$remark =~ s/(http:\/\/[^ \r\n]*)/<a href=\"$1\">$1<\/a>/gi;

# replace www.-specified sites
$remark =~ s/([ \t\n]|)(www.[^ \r\n]*)/$1<a href=\"http:\/\/$2\">http:\/\/$2<\/a>/g;

# replace blabla@blabla mailtos
$remark =~ s/([ \t\n]|)(([^ \r\n]+)\@([^ \r\n]+))/$1<a href=\"mailto:$2\">$2<\/a>/g;

$db = new pbase;
$db->open("data/ideas");

%row=%{$db->get("id", $id)};

if($permit ne $row{"passwd"}) {
    &Header("Bad Password");
    print "<p> I insist on getting the real actual password.";
    &Footer;
    exit;
}


$row{"remark"}= "$remark";
$row{"remarkdate"}= "$remarkdate";

$db->change("id", "$id", %row);
$db->save();

print "Location: display.cgi?id=$id&support=yes\n\n";

