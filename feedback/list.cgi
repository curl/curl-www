#!/usr/bin/perl

require "CGI.pm";
require "pbase.pm";
require "date.pm";

use feedback;

Top();
&where("Feedback", "/feedback/", "List Suggestions");
Header("List Suggestions");

$ideasperpage = 25;

$req = new CGI;

$sort = $req->param('sort');
$sortword = $req->param('dir');

$pagesize = $req->param('page');
if($pagesize) {
    $ideasperpage = $pagesize;
}
else {
    # default entries per page
    $ideasperpage = 25;
}
if($sort eq "") {
    # set default, swapped date order
    $sort = "modified";
    $sortword="swap";
}
elsif($sort eq "supporters") {
    $sort = "numsupports";
}

if($sortword eq "swap") {
    $sortdir = "-";
}
else {
    $sortdir = "";
}
$start=0+$req->param('start');
#$length=0+$req->param('length');
if($length == 0) {
    $length = $ideasperpage; # default
}

$db = new pbase;
$db->open("data/ideas");

my @allf=$db->find_all("modified" => "^\$");
foreach $f (@allf) {
    if(!$$f{'modified'}) {
        $$f{'modified'} = $$f{'when'};
    }
}

$db->sort($sortdir.$sort); # date-order

$amount = $db->size();

print <<STOPP

<p> Do you have an idea for improving curl, the tool, the lib, the docs or the
 web site?  Want to suggest a new feature or an improvement to an existing
 one?  Is there aditional documentation you\'d like to see? For complete
 discussions and talks, <a href="http://curl.haxx.se/mail/">join a mailing
 list</a> and take it there!

<p>
 This is the $amount suggestions submitted so far.
STOPP
    ;


if($amount == 0) {
    print "<p> <b>There doesn't seem to exist <i>any</i> suggestion right now!</b>";
}
else {
    $thispage = int($start/$ideasperpage)+1; # 1 is the first page
    $pages = int($amount/$ideasperpage);

    if($amount > $ideasperpage) {

        if($amount % $ideasperpage) {
            $pages += 1;
        }

        print "<p> Goto page :";
        $st = 0;
        $addurl="sort=$sort&amp;dir=$sortword&amp;page=$ideasperpage"; #&length=$length";
        for(1 .. $pages) {
            if($thispage == $_) {
                # we display this page now
                print "<b>$_</b> ";
            }
            else {
                print "<a href=\"list.cgi?start=$st&amp;$addurl\">[$_]</a> ";
            }
            $st += $ideasperpage;
        }
        print "\n Page size: ";

        foreach $page (25,50,75,100,500) {
            if($page != $ideasperpage) {
                $addurl="sort=$sort&amp;dir=$sortword&amp;page=$page"; #&length=$length";
                print "<a href=\"list.cgi?start=$start&amp;$addurl\">$page</a> ";
            }
            else {
                print "$page ";
            }
        }

        backwardsfowards();

    }
    $listit="list.cgi?page=$ideasperpage&amp;";
    
    print "<table cellspacing=0 cellpadding=2 border=0>\n";
    print "<tr class=\"tabletop\">",
    "<th><a href=\"${listit}sort=name\">Name</a>",
    "</th>",
    "<th><a href=\"${listit}sort=category\">Category</a>",
    "</th>",
    "<th><a href=\"${listit}\">Updated</a>",
    "</th>",
    "<th>Replies",
    "</th>",
    "<th><a href=\"${listit}sort=title\">Subject</a>",
    "</th>",
    "</tr>\n";

    if($start + $length > $amount) {
        $end = $amount;
    }
    else {
        $end = $start + $length;
    }

    for ($i=$start;$i<$end; $i++) {
        my %row=%{$db->get($i)};
        
        $cl = ($i&1)?"even":"odd";
        
        $when = $row{"modified"} || $row{"when"};
        if($when =~ /(\d*)-(\d*)-(\d*)/) {
            #       $nicedate= &MonthNameEng($2)." ".$3.", ".$1;
            $nicedate = sprintf("%.3s %d %d",
                                &MonthNameEng($2), $3, $1);
        }
        else {
            $nicedate = $when;
        }
        
        $id = $row{"__id"};

        $supps = 0 + $row{"numsupports"};

        $emai = $row{"email"};
        $emai =~ s/@/ at /;
        $emai =~ s/\./ dot /;
        
        print "<tr class=\"$cl\" valign=\"top\">\n",
        "<td><a href=\"mailto:$emai\">".$row{"name"}."</a></td>",
        "<td>".$row{"category"}."</td>",
        "<td nowrap>$nicedate</td>",
        "<td align=\"center\">$supps</td>\n";
        
        print "<td valign=\"top\" nowrap>",
        "<a href=\"display.cgi?id=$id&amp;support=yes\">";
        $t= $row{"title"};

        if(length($t) > 45) {
            print substr($t, 0, 43)."...";
        }
        else {
            if($t) {
                print "$t";
            }
            else {
                print "(no title)";
            }
        }

        print "</a></td>\n";
        print "</tr>"; # end of info-line

        if($verbose) {
            print "<tr bgcolor=\"$cl\">",
            "<td>&nbsp;</td><td colspan=5><i><font size=+1>".$row{"idea"};
            print "</i></font></td></tr>\n";
        }
    }
    $db->close();

    print "</table>\n";
}

backwardsfowards();

sub backwardsfowards {

    print "<table width=\"100%\"><tr><td align=\"left\">\n";
    $addurl="sort=$sort&amp;dir=$sortword&amp;page=$ideasperpage"; #&length=$length";
    if($thispage > 1) {
        $st = ($thispage -2)*$ideasperpage;
        if($st < 0) {
            $st = 0;
        }
        print "<a href=\"list.cgi?start=$st&amp;$addurl\">[<= Previous $ideasperpage Entries]</a> ";
    }
    else {
        print "&nbsp;";
    }
    printf "</td><td align=\"center\">%d - %d</td><td align=\"right\">\n",
    ($thispage-1) * $ideasperpage + 1,
    ($thispage * $ideasperpage);
    if($thispage < $pages) {
        $st = ($thispage ) * $ideasperpage;
        if($st < $amount) {
            print "<a href=\"list.cgi?start=$st&amp;$addurl\">[Next $ideasperpage Entries =>]</a> ";
        }
    }
    print "</td></tr></table>\n";
}

Footer;
