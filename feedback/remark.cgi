#!/usr/bin/perl

require "CGI.pm";
require "pbase.pm";
require "date.pm";

use feedback;

Top();
Header("Add a Remark to Your Suggestion");

$req = new CGI;

$id = $req->param('id');

$db = new pbase;
$db->open("data/ideas");

%row=%{$db->get("id", $id)};

print <<SLUT

<p> This must be your suggestion. You can add a remark to it, that will then
 be visible next to the suggestion text in all suggestion displays. You can
 and use this remark field to update your suggestion based on comments or on
 new knowledge in the field.

<p> You cannot change the original suggestion text, and you must remember the
 password to specified when you added the suggestion.

<p>
 Do <b>not</b> use HTML in the comment, it will get cut off anyway.

<p>
 <h3>Your Suggestion You Add A Remark For</h3>
SLUT
    ;

print "<table bgcolor=\"#000000\" cellspacing=2 cellpadding=2 border=0><tr><td>\n";
print "<table bgcolor=\"#ffffff\" cellspacing=0 cellpadding=2 border=0>\n";

$when = $row{"when"};
if($when =~ /(\d*)-(\d*)-(\d*)/) {
    $nicedate = sprintf("%s %d, %d",
                        &MonthNameEng($2), $3, $1);
}
else {
    $nicedate = $when;
}

$cl = "bgcolor=#cccccc";
print "<tr><td $cl valign=top>Name</td><td>".$row{"name"}." &lt;<i>".$row{"email"}."</i>&gt; $editmsg</td></tr>";
print "<tr><td $cl>Category</td><td>".$row{"category"}."</td></tr>";
print "<tr><td $cl>When</td><td>$nicedate</td></tr>";
print "<tr><td valign=top $cl>Text</td><td valign=top><i><font size=+1>".$row{"idea"};
print "</i></font></td></tr>\n";

$db->close();

print "</table>\n";
print "</td></tr></table>\n";


$rem=$row{"remark"};

print <<EOD
<form action="addremark.cgi" method="post">
<center>
<table bgcolor="#000000" cellspacing=2 cellpadding=2 border=0><tr><td>
<table bgcolor="#cccccc" cellspacing=0 cellpadding=3 border=0>
<tr><td>Password </td><td> <input type=password name=passwd value="" size=10></tr>
<tr><td colspan=2>Remark</td></tr>
<tr><td colspan=2>
 <textarea name=remark rows=6 cols=60 wrap=virtual>$rem</textarea></td></tr>
<tr><td align=center colspan=2><input type=submit value="save" name=submit></td></tr>
</table>
</td></tr></table>
</center>
<input type=hidden name=id value="$id">

</form>
EOD
    ;


Footer;
