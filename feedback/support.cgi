#!/usr/bin/perl

require "CGI.pm";
require "pbase.pm";
require "date.pm";

use feedback;

Top();
Header("Comment a Suggestion");

$req = new CGI;

$id = $req->param('id');

$db = new pbase;
$db->open("data/ideas");

%row=%{$db->get("id", $id)};

print <<SLUT

<p> This is a suggestion. You can comment this particular suggestion by adding
 text in the form below. <b>Please</b> do not comment your own suggestions, it
 effectively ruins this system.
<p>
 Do <b>not</b> use HTML in the comment, it will get cut off anyway.
<p>
 You will <b>not</b> be able to modify your comment once you've posted it. Be
 polite and try to be constructive.

<p>
 <h3>Suggestion You Are About To Comment</h3>
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


$rem =$row{"remark"};
print "<tr><td $cl>Title</td><td><b>".$row{"title"}."</b></td></tr>";
print "<tr><td $cl valign=top>Name</td><td>".$row{"name"}." &lt;<i>".$row{"email"}."</i>&gt; $editmsg</td></tr>";
print "<tr><td $cl>Category</td><td>".$row{"category"}."</td></tr>";
print "<tr><td $cl>When</td><td>$nicedate</td></tr>";
print "<tr><td valign=top $cl>Text</td><td valign=top><i><font size=+1>".$row{"idea"};
print "</i></font></td></tr>\n";
if($rem ne "") {
    print "<tr><td valign=top $cl>Remark</td><td valign=top><b>$rem",
    "</b></td></tr>\n";
}

$db->close();

print "</table>\n";
print "</td></tr></table>\n";


print <<EOD
<form action="addsupport.cgi" method="post">
<center>
<table bgcolor="#000000" cellspacing=2 cellpadding=2 border=0><tr><td>
<table bgcolor="#cccccc" cellspacing=0 cellpadding=3 border=0>
<tr><td>Name     </td><td> <input type=text name=name value="" size=50></tr>
<tr><td>Email    </td><td> <input type=text name=email value="" size=50></tr>
<tr><td colspan=2>Comment</td></tr>
<tr><td colspan=2>
 <textarea name=comment rows=6 cols=60 wrap=virtual></textarea></td></tr>
<tr><td align=center colspan=2><input type=submit value="save" name=submit></td></tr>
</table>
</td></tr></table>
</center>
<input type=hidden name=id value="$id">

</form>
EOD
    ;


Footer;
