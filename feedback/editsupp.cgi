#!/usr/bin/perl

require "CGI.pm";
require "pbase.pm";
require "date.pm";

use feedback;

Top();
Header("Edit Supporting Comments");

$req = new CGI;

$id = $req->param('id');
$support = $req->param('support');

$db = new pbase;
$db->open("data/ideas");

%row=%{$db->get("id", $id)};

print <<SLUT
<p>
 Edit the supporter stuff below
<p>
SLUT
    ;

print "<table bgcolor=\"#000000\" cellspacing=2 cellpadding=2 border=0><tr><td>\n";
print "<table bgcolor=\"#ffffff\" cellspacing=0 cellpadding=2 border=0>\n";


    
$when = $row{"when"};
if($when =~ /^(\d\d\d\d)-(\d\d)-(\d\d)$/) {
    $nicedate = sprintf("%s %d, %d",
                        &MonthNameEng($2), $3, $1);
}
else {
    $nicedate = $when;
}

$edit = $row{"edit"};
if($edit) {
    $editwhen=$row{"editdate"};
    if($editwhen =~ /^(\d\d\d\d)-(\d\d)-(\d\d)$/) {
        $nicewhen = sprintf("on %s %d, %d",
                            &MonthNameEng($2), $3, $1);
    }
    $editmsg = "<small>(edited by $edit $nicewhen)</small>";
}
$supps = $row{"numsupports"};

$cl = "bgcolor=#cccccc";
print "<tr><td $cl valign=top>Name</td><td>".$row{"name"}." &lt;<i>".$row{"email"}."</i>&gt; $editmsg</td></tr>\n";
print "<tr><td $cl>Category</td><td>".$row{"category"}."</td></tr>\n";
print "<tr><td $cl>When</td><td>$nicedate</td></tr>\n";

print "<tr><td valign=top $cl>Text</td><td valign=top><i><font size=+1>".$row{"idea"};
print "</i></font></td></tr>\n";

print "</table>\n";
print "</td></tr></table>\n";

if($supps) {
    print "<h2>Supporters</h2>\n";

    print "<table bgcolor=\"#000000\" cellspacing=2 cellpadding=2 border=0><tr><td>\n";
    print "<table bgcolor=\"#ffffff\" cellspacing=0 cellpadding=2 border=0>\n";

    for(1 .. $supps) {
        $si = $_-1;

        $na = "&nbsp;".$row{"suppname$si"};
        $em = "&nbsp;".$row{"suppemail$si"};
        $da = "&nbsp;".$row{"suppdate$si"};
        $co = "&nbsp;".$row{"suppcomment$si"};

        $cl = "bgcolor=#cccccc";
        print "<tr><td $cl valign=top>Name</td><td>$na &lt;<i>$em</i>&gt;</td></tr>\n";
        print "<tr><td $cl>Date</td><td>$da</td></tr>\n";
        print "<tr><td $cl>Comment</td><td>$co</td></tr>\n";
        print "<tr><td $cl>&nbsp;</td><td> <a href=\"fixsupp.cgi?id=$id&supp=$si\">[EDIT]</a> </td></tr>\n";

    }
    print "</table>\n";
    print "</td></tr></table>\n";
}

$db->close();

print "<p><small><a href=\"edit.cgi?id=$id\">edit</a></small>\n";

Footer;
