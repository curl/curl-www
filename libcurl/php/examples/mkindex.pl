#!/usr/bin/perl

require "/home/dast/perl/date.pm";
require "../../../curl.pm";

require "CGI.pm";

sub listexamples {
    print <<MOO
<p>
 We try to collect examples on how to program the PHP/CURL interface
 here. If you have any source snippests you want to share with the rest of the
 world, please let <a href="mailto:curl-web@haxx.se">us</a> know!
MOO
    ;

    my $some_dir=".";
    opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
    my @ex = grep { /\.php$/ && -f "$some_dir/$_" } readdir(DIR);
    closedir DIR;

    print "<p><table border=\"0\" cellpadding=\"2\" cellspacing=\"0\"><tr class=\"tabletop\">",
    "<th>Example</th>",
    "<th>Description</th>",
    "</tr>\n";

    my $c;
    for(sort @ex) {
        $filename = $_;
        
        my $class= ($c++&1)?"odd":"even";
        print "<tr class=\"$class\" valign=\"top\"><td>";

        my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
            $atime,$mtime,$ctime,$blksize,$blocks)
            = stat($filename);

        my $exfile = $filename;

        $exfile =~ s/\.php$/.html/;

        my $fileshow = $filename;

        $fileshow =~ s/\.php$//;
        
        print "<a href=\"./$exfile\">$fileshow</a></td><td>\n";
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

&catfile("../examples.html");

{
    where("libcurl", "/libcurl/",
          "PHP", "/libcurl/php/",
          "Examples");

    &title("PHP/CURL Examples Collection");
    listexamples();
}

# get example file name from argv
$ex = $ARGV[0];

if($ex) {
    if($ex =~ /\.\./) {
        $ex = "invalid";
    }
    else {
        $ex =~ s/.*\/(.*)/$1/;
    }

     
 #   where("libcurl", "/libcurl/",
 #         "PHP", "/libcurl/php/",
 #         "Examples", "/libcurl/php/examples/",
 #         $ex);
    subtitle("The $ex Example");

    if( -r "$ex.html") {
        catfile("$ex.html");
    }
    print "<p><div class=\"quote\">\n";
    precatfile($ex);
    print "</div>\n";
}

footer();

