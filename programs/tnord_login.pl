#!/usr/bin/perl

# This script logs in to telenordia broadband using https
#
# Needed:
# openssl, curl
#
# Made by roberth@edberg-it.se 2001.10.16
#

# Personal stuff
$name="username";
$passw="passwd";

# Just a cleanup
$name=~ s/([^a-zA-Z0-9_.-])/uc sprintf("%%%02X",ord($1))/eg;
$passwd=~ s/([^a-zA-Z0-9_.-])/uc sprintf("%%%02X",ord($1))/eg;

# Path to curl
$curl="/usr/local/bin/curl";

# URLs
$baseurl="https://login.telenordia.se/login";
$loginpage="$baseurl/checkuser.php3";

$cmd="$curl -d \"name=$name&passw=$passw\"  $loginpage";

@main = `$cmd`;
$status=1;
foreach $main_line (@main) {
	if ($main_line =~ /\<script\>openSessionWindow/) {
		$status=0;
	}
	print $main_line;
}
exit $status;
