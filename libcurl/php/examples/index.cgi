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

    print "<p><table border=\"0\" cellpadding=\"1\" cellspacing=\"0\"><tr class=\"tabletop\">",
    "<th>Example</th>",
    "<th>Description</th>",
    "</tr>\n";

    my $c;
    for(@ex) {
        $filename = $_;
        
        my $class= ($c++&1)?"odd":"even";
        print "<tr class=\"$class\" valign=\"top\"><td>";

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

$req = new CGI;
$ex = $req->param('ex');

if($ex) {
    if($ex =~ /\.\./) {
        $ex = "invalid";
    }
    else {
        $ex =~ s/.*\/(.*)/$1/;
    }
    
    where("libcurl", "/libcurl/",
          "PHP", "/libcurl/php/",
          "Examples", "/libcurl/php/examples/",
          $ex);
    &title("The $ex Example");

    if( -r "$ex.html") {
        &catfile("$ex.html");
    }

    precatfile($ex);
}
else {
    where("libcurl", "/libcurl/",
          "PHP", "/libcurl/php/",
          "Examples");

    &title("PHP/CURL Examples Collection");
    listexamples();
}

&catfile("../../../foot.html");

