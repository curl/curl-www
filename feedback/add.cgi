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
$title = $req->param('title');
$passwd = $req->param('passwd');
$preview = $req->param('preview');
$cancel = $req->param('cancel');

if($cancel ne "") {
    print "Location: ./\n\n";
    exit;
}

$now = sprintf("%04d-%02d-%02d", &ThisYear, &ThisMonth, &ThisDay);

# Get versions of these fields that are non-offensive
$cleantitle = &cleantext($title, 0);
$cleanname = &cleantext($name, 0);
$cleanemail = $email;
$cleanidea = &cleantext($idea, 1);

my @ahref = split("a href", $cleanidea);
my $ahrefnum = scalar(@ahref) -1;

if($ahrefnum > 2) {
    &Top();
    &Header("URL flood");
    print "<p> You're not allowed to include that many URLs. Please trim your",
    " message and re-submit.";
    &Footer;
    exit;
}

if($preview ne "") {
    Top();
    # This is a preview-only!
    Header("Suggestion Preview!");

    print <<POO
<p>
 This is how your entered suggestion will look like when posted for real!
<p>
 The password field is there to allow you to add a remark to your suggestion
 at a later time. The suggested password may be changed at will. <b>You will
 not see it again, remember it!</b> You cannot change the suggestion after it
 has been posted. Stay polite and focused.
<p>
POO
;

    print "<table bgcolor=\"#000000\" cellspacing=2 cellpadding=2 border=0><tr><td>\n";
    print "<table bgcolor=\"#ffffff\" cellspacing=0 cellpadding=2 border=0>\n";

    $when = $now;
    if($when =~ /^(\d\d\d\d)-(\d\d)-(\d\d)$/) {
        $nicedate = sprintf("%s %d, %d",
                            &MonthNameEng($2), $3, $1);
    }
    else {
        $nicedate = $when;
    }

    $cl = "bgcolor=#cccccc";
    print "<tr><td $cl>Title</td><td><b>$cleantitle</b></td></tr>\n";

    print "<tr><td $cl valign=top>Name</td><td>$name &lt;<a href=\"mailto:$cleanemail\">$cleanemail</a>&gt;</td></tr>\n";
    print "<tr><td $cl>Category</td><td>$category</td></tr>\n";
    print "<tr><td $cl>When</td><td>$nicedate</td></tr>\n";

    print "<tr><td valign=top $cl>Text</td><td valign=top><i><font size=+1>$cleanidea</i></font></td></tr>\n";

    print "</table>\n";
    print "</td></tr></table>\n";

    @allcats = &GetCategories;
    for(@allcats) {
        my $sel = ($_ eq $category)?" SELECTED":"";
        $cats .= "<option$sel>$_</option>\n";
    }

    print <<ENTER
<p><b>Edit in your suggestion/idea:</b>
ENTER
    ;

    &ShowInput;

    print <<POO
<p>
 You can still avoid posting this suggestion by simply follow another link away from this page.
POO
    ;
    Footer;

    exit;
}

if(length($passwd) < 4) {
    &Top();
    &Header("bad password");
    print "<p> I insist on getting a <b>longer</b> password.";
    &Footer;
    exit;
}

if(length($title) < 4) {
    &Top();
    &Header("bad title");
    print "<p> I insist on getting a sensible and proper title.";
    &Footer;
    exit;
}


$db = new pbase;
$db->open("data/ideas");
$id = $db->add("name", "$cleanname",
               "email", "$cleanemail",
               "category", "$category",
               "idea", "$cleanidea",
               "title", "$cleantitle",
               "when", "$now",
               "modified", "$now",
               "passwd", "$passwd");
$db->save();

print "Location: display.cgi?id=$id\n\n";

