#!/usr/local/bin/perl

require "/home/dast/perl/date.pm";
require "../../../curl.pm";

require "CGI.pm";

sub listexamples {
    print <<MOO
<p>
 We try to collect examples on how to program the CURL interface from PHP
 here. If you have any source snippests you want to share with the rest of the
 world, please let us know!
MOO
    ;

    my $some_dir=".";
    opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
    my @ex = grep { /\.php$/ && -f "$some_dir/$_" } readdir(DIR);
    closedir DIR;

    my $neat ="<font color=\"#ffffff\" size=+1 face=\"ariel,helvetica\">";
    my $neatend = "</font>";

    print "<p><table border=0 cellpadding=1 cellspacing=0><tr bgcolor=\"#0000ff\">",
    "<td>$neat Example $neatend</td>",
    "<td>$neat Description $neatend</td>",
    "</tr>\n";

    for(@ex) {
        $filename = $_;
        
        if($c++&1) {
            $col=" bgcolor=\"#e0e0e0\"";
        }
        else {
            $col="";
        }
        
        print "<tr valign=top$col><td>";

        my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
            $atime,$mtime,$ctime,$blksize,$blocks)
            = stat($filename);
        
        print "<a href=\"./?ex=$filename\">$filename</a></td><td>\n";
        if( -r "$filename.html") {
            &catfile("$filename.html");
        }
        else {
            print "&nbsp;";
        }
        print "</td></tr>\n";
    }
    print "</table>\n";   
}

print "Content-Type: text/html\n\n";

&catfile("../examples.html");

where("libcurl", "/libcurl/", "PHP", "/libcurl/PHP/", "PHP Examples");

&title("PHP/CURL Examples Collection");

$req = new CGI;
$ex = $req->param('ex');

if($ex) {
    $ex =~ s/.*\/(.*)/$1/;
    
    if( -r "$ex.html") {
        &catfile("$ex.html");
    }

    precatfile($ex);
}
else {
    listexamples();
}

&catfile("../../../foot.html");

print "</body></html>\n";
