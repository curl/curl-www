#!/usr/bin/perl

require "CGI.pm";
require "pbase.pm";
require "date.pm";

use feedback;

$req = new CGI;

$name = $req->param('name');
$email = $req->param('email');
$category = $req->param('category');
$idea = $req->param('idea');
$remark = $req->param('remark');
$when = $req->param('when');
$title = $req->param('title');
$id = $req->param('id');
$edit = $req->param('edit');
$delete = $req->param('delete');
$passwd = $req->param('passwd'); # suggestion-specific password

$permit = $req->param('permit');

if($adminpasswd ne $permit) {
    &Header("bad password");
    print "<p> I insist on getting the actual password.";
    &Footer;
    exit;
}
if($delete ne "") {
    #delete this entry!
    $db = new pbase;
    $db->open("data/ideas");

    $db->delete("id", $id);
    $db->save();

    print "Location: list.cgi\n\n";
    exit;
}


$now = sprintf("%04d-%02d-%02d", &ThisYear, &ThisMonth, &ThisDay);

$db = new pbase;
$db->open("data/ideas");

%row=%{$db->get("id", $id)};

$row{"name"}= "$name";
$row{"email"}= "$email";
$row{"category"}= "$category";
$row{"idea"}= "$idea";
$row{"remark"}= "$remark";
$row{"edit"}= "$edit";
$row{"editdate"}= "$now";
$row{"when"}= "$when";
$row{"title"}= "$title";

if($passwd ne "") {
    $row{"passwd"}=$passwd;
}

$db->change("id", "$id", %row);
$db->save();

print "Location: display.cgi?id=$id\n\n";

