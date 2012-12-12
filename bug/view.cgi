#!/usr/bin/perl

require "CGI.pm";
require "../curl.pm";

my $num = CGI::param('id');

# remove non-digits
$num =~ s/[^0-9]//g; 

if($num < 1) {
    print "Content-Type: text/html\n\n";

    header("View a Bug Report");

    print <<MOO
<form action="view.cgi" method="GET">
Enter bug report number:
<input type="text" name="id">
<input type="submit" name="view">
</form>

The number is one of those in the <a href="http://sourceforge.net/bugs/?group_id=976">sourceforge bug tracker</a> for the cURL project.
MOO

;
    footer();

}
elsif($num < 10000) {
    # low numbers are assumed to be the "new" numbers since the switch we 
    # did on Dec 12 2012
    print "Location: https://sourceforge.net/p/curl/bugs/$num/\n\n";
}
else {
    print "Location: http://sourceforge.net/tracker/index.php?func=detail&aid=$num&group_id=976&atid=100976\n\n";
}
