#!/usr/bin/perl

require "CGI.pm";
require "pbase.pm";
require "date.pm";

use feedback;

Top();
Header("Edit suggestion");

$req = new CGI;

$id = $req->param('id');

$db = new pbase;
$db->open("data/ideas");

%row=%{$db->get("id", $id)};

print <<SLUT

<p> Using this form, a suggestion can be changed. It <b>requires</b> you to
 know the edit password, so <i>if you're not the admin, forget about this!</i>

SLUT
    ;

$name=$row{"name"};
$email=$row{"email"};
$category=$row{"category"};
$idea=$row{"idea"};
$when=$row{"when"};
$title=$row{"title"};
$passwd=$row{"passwd"};

@allcats = &GetCategories;
for(@allcats) {
    if($_ eq $category) {
        $cats .= "<option selected>$_</option>";
    }
    else {
        $cats .= "<option>$_</option>";
    }
}

$rem=$row{"remark"};
if($rem ne "") {
    $remtext=sprintf("<tr><td colspan=2>Remark</td></tr>%s%s",
"<tr><td colspan=2>",
"<textarea name=remark rows=10 cols=60 wrap=virtual>$rem</textarea></td></tr>");
}

print <<EOD
<form action="change.cgi" method="post">
<center>
<table bgcolor="#000000" cellspacing=2 cellpadding=2 border=0><tr><td>
<table bgcolor="#cccccc" cellspacing=0 cellpadding=3 border=0>
<tr><td>Name     </td><td> <input type=text name=name value="$name" size=50></tr>
<tr><td>Email    </td><td> <input type=text name=email value="$email" size=50></tr>
<tr><td>New passwd</td><td> <input type=text name=passwd value="" size=20></tr>
<tr><td>Category </td><td> <select name=category>$cats</select> </td></tr>
<tr><td>Title    </td><td> <input type=text name=title value="$title" size=50></tr>
<tr><td colspan=2>Suggestion</td></tr>
<tr><td colspan=2>
 <textarea name=idea rows=10 cols=60 wrap=virtual>$idea</textarea></td></tr>
$remtext
<tr><td align=center colspan=2><input type=submit value="submit" name=submit><input type=submit value="delete" name=delete></td></tr>
<tr><td>Edited by</td><td> <input type=text name=edit value=""></tr>
<tr><td>Password </td><td> <input type=password name=permit value=""></tr>
</table>
</td></tr></table>
</center>
<input type=hidden name=id value="$id">
<input type=hidden name=when value="$when">
</form>
EOD
    ;

print "<h3>Posted suggestion:</h3>\n";
print "<table bgcolor=\"#000000\" cellspacing=2 cellpadding=2 border=0><tr><td>\n";
print "<table bgcolor=\"#ffffff\" cellspacing=0 cellpadding=2 border=0>\n";
{
    $cl = "bgcolor=#cccccc";
    
    $when = $row{"when"};
    if($when =~ /(\d*)-(\d*)-(\d*)/) {
        $nicedate = sprintf("%s %d, %d",
                            &MonthNameEng($2), $3, $1);
    }
    else {
        $nicedate = $when;
    }

    print "<tr><td $cl valign=top>Name</td><td>".$row{"name"}." &lt;<i>".$row{"email"}."</i>&gt;</td></tr>";
    print "<tr><td $cl>Category</td><td>".$row{"category"}."</td></tr>";
    print "<tr><td $cl>When</td><td>$nicedate</td></tr>";
    print "<tr><td $cl>Title</td><td>".$row{"title"}."</td></tr>";

    print "<tr><td valign=top $cl>Text</td><td valign=top><i><font size=+1>".$row{"idea"};
    print "</i></font></td></tr>\n";
 }
$db->close();

print "</table>\n";
print "</td></tr></table>\n";

if($row{"numsupports"}) {
    print "<p><small><a href=\"editsupp.cgi?id=$id\">edit support comments</a></small>\n";
}

Footer;
