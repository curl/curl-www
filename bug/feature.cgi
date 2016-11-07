#!/usr/bin/perl

require "CGI.pm";
require "../curl.pm";

my $num = CGI::param('id');

# remove non-digits
$num =~ s/[^0-9]//g;

if($num < 10000) {
    print "Content-Type: text/html\n\n";

    header("View a Bug Report");

    print <<MOO
<form action="view.cgi" method="GET">
Enter bug report number:
<input type="text" name="id">
<input type="submit" name="view">
</form>

The number is one of those in the <a href="https://sourceforge.net/bugs/?group_id=976">sourceforge bug tracker</a> for the curl project.
MOO

;
    footer();

}
else {
    print "Location: https://sourceforge.net/tracker/index.php?func=detail&aid=$num&group_id=976&atid=350976\n\n";
}
