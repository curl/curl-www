#!/usr/bin/perl

require "CGI.pm";
require "pbase.pm";
require "date.pm";

use feedback;

$req = new CGI;

$supp = $req->param('supp');
$passwd = $req->param('passwd');
$id = $req->param('id');
$delete = $req->param('delete');
$save = $req->param('save');

if($adminpasswd ne $passwd) {
    &Header("bad password");
    print "<p> I insist on getting the actual password.";
    &Footer;
    exit;
}

$db = new pbase;
$db->open("data/ideas");

%row=%{$db->get("id", $id)};

if($delete ne "") {
    $nums = $row{"numsupports"}-1;
    for($i=$supp; $i<nums; $i++) {
        $j=$i+1;
        $row{"suppname$i"}= $row{"suppname$j"};
        $row{"suppemail$i"}= $row{"suppemail$j"};
        $row{"suppdate$i"}= $row{"suppdate$j"};
        $row{"suppcomment$i"}= $row{"suppcomment$j"};
    }
    $row{"numsupports"}=$nums;
}
else {
    $i=$supp;
    $row{"suppname$i"}=$req->param('name');
    $row{"suppemail$i"}= $req->param('email');
    $row{"suppcomment$i"}= $req->param('comment');

    if($row{"suppdate$i"} eq "") {
        $row{"suppdate$i"}=
            sprintf("%04d-%02d-%02d", &ThisYear, &ThisMonth, &ThisDay);
    }
}

$db->change("id", "$id", %row);
$db->save();

print "Location: editsupp.cgi?id=$id\n\n";

