#!/usr/bin/perl

require "CGI.pm";
require "pbase.pm";
require "date.pm";

use feedback;

$maxcommperpage = 5;

Top();
&where("Feedback", "/feedback/", "Display Suggestion");
Header("A suggestion");

$req = new CGI;

$id = $req->param('id');
$support = $req->param('support');

$single = $req->param('single');

$start = 0+$req->param('start');
if($start < 1) {
    $start = 1;
}

$db = new pbase;
$db->open("data/ideas");

%row=%{$db->get("id", $id)};

print <<SLUT
<p>
 This is a single suggestion. Use the list option above to see other.

<p> To comment this suggestion, press the "<i>I wanna comment this
 suggestion</i>" button and follow the instructions on the next page.

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

$emai = $row{"email"};
$emai =~ s/@/ at /;
$emai =~ s/\./ dot /;

print "<tr><td $cl>Title</td><td><b>".$row{"title"}."</b></td></tr>\n";
print "<tr><td $cl valign=top>Name</td><td>".$row{"name"}." &lt;<a href=\"mailto:$emai\">$emai</a>&gt; $editmsg</td></tr>\n";
print "<tr><td $cl>Category</td><td>".$row{"category"}."</td></tr>\n";
print "<tr><td $cl>When</td><td>$nicedate</td></tr>\n";

print "<tr><td valign=top $cl>Text</td><td valign=top><i><font size=+1>".$row{"idea"},
    "</i></font></td></tr>\n";
$rem =$row{"remark"};
if($rem ne "") {
    print "<tr><td valign=top $cl>Remark</td><td valign=top><b>$rem",
    "</b></td></tr>\n";
}

if($supps>0) {
    print "<tr><td $cl>Commented by</td><td>$supps persons";

    if($support eq "") {
        print " [<a href=\"display.cgi?id=$id&support=yes\">display comments</a>]";
    }
    else {
        print " [<a href=\"display.cgi?id=$id\">hide comments</a>]";
    }
    print "</td></tr>";    
}


print "</table>\n";
print "</td></tr></table>\n";

print "<table><tr>\n";
print "<td><form action=\"support.cgi\" method=\"GET\">\n",
    "<input type=submit name=comment value=\"I wanna comment this suggestion!\">\n",
    "<input type=hidden name=id value=\"$id\">\n",
    "</form></td>\n";

print "<td><form action=\"remark.cgi\" method=\"GET\">\n",
    "<input type=submit name=comment value=\"I'm the author, I'd like to ",
    ($rem eq ""?"add a ":"edit my"),
     " remark!\">\n",
     "<input type=hidden name=id value=\"$id\">\n",
     "</form></td>\n";
print "</tr></table>\n";

#print "<tr><td $cl>Comment</td><td>\n",
#    "<a href=\"support.cgi?id=$id\">I wanna comment this suggestion!</a>",
#    "</td></tr>\n";



if(($support eq "yes") && $supps) {
    if($start + $maxcommperpage >= $supps) {
        $end = $supps;
    }
    else {
        $end = $start + $maxcommperpage-1;
    }
    if($single ne "") {
        $end = $start;
    }

    print "<h2>Comments</h2>\n",
    "<p><b> $supps comments found</b>\n";

    $addurl="id=$id&support=$support";

    if($single) {
        print "<a href=\"./display.cgi?$addurl\">view all</a>";
    }


    if( $supps > $maxcommperpage) {
        my $pages = int($supps/$maxcommperpage);
        $thispage = int($start/$maxcommperpage)+1; # 1 is the first page

        if($supps % $maxcommperpage) {
            $pages += 1;
        }

        print "<p> Goto page :";
        $st = 1;
        for(1 .. $pages) {
            if($thispage == $_) {
                # we display this page now
                print "[$_] ";
            }
            else {
                print "<a href=\"display.cgi?start=$st&$addurl\">[$_]</a> ";
            }
            $st += $maxcommperpage;
        }
        print "\n";

        


    }

    print "<table bgcolor=\"#000000\" cellspacing=2 cellpadding=2 border=0><tr><td>\n";
    print "<table bgcolor=\"#ffffff\" cellspacing=0 cellpadding=2 border=0>\n";

    for($start .. $end) {
        $si = $_-1;
        $num = $_;

        $na = $row{"suppname$si"};
        $na = "&nbsp;" if($na eq "");

        $em = $row{"suppemail$si"};

        $da = $row{"suppdate$si"};
        $da = "&nbsp;" if($da eq "");

        if($da =~ /^(\d\d\d\d)-(\d\d)-(\d\d)$/) {
            $da = sprintf("%s %d, %d",
                          &MonthNameEng($2), $3, $1);
        }

        $co = $row{"suppcomment$si"};
        $co = "&nbsp;" if($co eq "");

        $cl = ($num&1)?"bgcolor=#ffffff":"bgcolor=#cccccc";

        print "<tr $cl><td>$num</td><td>$na &lt;<a href=\"mailto:$em\">$em</a>&gt; posted $da (<a href=\"display.cgi?id=$id&support=yes&start=$num&single=yes\">direct-link</a>)</td></tr>",
        "<tr $cl><td valign=top> &nbsp</td><td><i>$co</i></td></tr>\n",

    }
    print "</table>\n";
    print "</td></tr></table>\n";
}

$db->close();

print "<p><small><a href=\"edit.cgi?id=$id\">admin</a></small>\n";

Footer;
