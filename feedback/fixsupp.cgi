#!/usr/bin/perl

require "CGI.pm";
require "pbase.pm";
require "date.pm";

use feedback;

Top();
Header("Correct A Comment");

$req = new CGI;

$id = $req->param('id');
$supp = $req->param('supp');

$db = new pbase;
$db->open("data/ideas");

%row=%{$db->get("id", $id)};

print <<SLUT
<p>
 The form below is to be used to edit or delete a comment to a posted
 suggestion.
<p>
SLUT
    ;

$supps = $row{"numsupports"};

if($supps) {

    print "<table bgcolor=\"#000000\" cellspacing=2 cellpadding=2 border=0><tr><td>\n";
    print "<table bgcolor=\"#ffffff\" cellspacing=0 cellpadding=2 border=0>\n";

    for(1 .. $supps) {
        $si = $_-1;

        if($si == $supp) {
            
            $na = $row{"suppname$si"};
            $em = $row{"suppemail$si"};
            $co = $row{"suppcomment$si"};

            $cl = "bgcolor=#cccccc";
            
            print "<form action=\"editcomm.cgi\" method=post>",
            "<tr><td $cl valign=top>Name</td><td><input type=text name=name value=\"$na\" size=50></td></tr>\n",
            "<tr><td $cl valign=top>Email</td><td><input type=text name=email value=\"$em\" size=50></td></tr>\n",
            "<tr><td $cl>Comment</td><td><textarea name=comment rows=10 cols=60>$co</textarea></td></tr>\n",
            "<tr><td $cl valign=top>Password</td><td><input type=password name=passwd value=\"\"></td></tr>\n",
            "<tr><td colspan=2 align=center><input type=submit name=save value=\"save\"> \n",
            "<input type=submit name=delete value=\"delete\"></td></tr>\n",
            "<input type=hidden name=id value=\"$id\">",
            "<input type=hidden name=supp value=\"$supp\">",
            "</form>";
            
        }
    }
    print "</table>\n";
    print "</td></tr></table>\n";
}

$db->close();

print "<p><a href=\"display.cgi?id=$id\">display suggestion</a></small>\n";

Footer;
