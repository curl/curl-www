#!/usr/bin/perl

require "CGI.pm";
require "pbase.pm";
require "date.pm";

use feedback;

$req = new CGI;

$suppname = $req->param('name');
$suppemail = $req->param('email');
$comment = $req->param('comment');
$id = $req->param('id');

$now = sprintf("%04d-%02d-%02d", &ThisYear, &ThisMonth, &ThisDay);

# clean up possible user mess:
$comment = &cleantext($comment, 1);

$db = new pbase;
$db->open("data/ideas");

%row=%{$db->get("id", $id)};

$suppindex = 0+$row{"numsupports"};
$numsupports = 1 + $suppindex;

$row{"suppname$suppindex"}= "$suppname";
$row{"suppemail$suppindex"}= "$suppemail";
$row{"numsupports"} = "$numsupports";
$row{"suppdate$suppindex"}= "$now";
$row{"suppcomment$suppindex"}= "$comment";
$row{"modified"}="$now";

$db->change("id", "$id", %row);
$db->save();

print "Location: display.cgi?id=$id&support=yes\n\n";

