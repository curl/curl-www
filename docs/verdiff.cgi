#!/usr/bin/perl

require "CGI.pm";
require "../curl.pm";

my $r = new CGI;

my $r1 = $r->param('r1');
my $r2 = $r->param('r2');

print "Content-Type: text/html\n\n";

&catfile("../head.html");

if($r1 && $r2) {
    &title("Show changelog entries between $r1 and $r2");
}
else {
    &title("Show changelog entries between two versions");
}

open(CH, "<changes.t");

# display the choices

push @vers, "CVS";
while(<CH>) {
    chomp;
    if($_ =~ /Version ([^ ]*)/) {
        push @vers, $1;
    }
}
close(CH);

print 
    "<form action=\"verdiff.cgi\">",
    "Show changelog entries between: ",
    "<select name=\"r1\">\n";

for(@vers) {
    my $s="";
    if($_ eq $r1) {
        $s = " SELECTED";
    }
    print "<option$s>$_</option>\n";
}
print "</select> and <select name=\"r2\">\n";
for(@vers) {
    my $s="";
    if($_ eq $r2) {
        $s = " SELECTED";
    }
    print "<option$s>$_</option>\n";
}
print "</select><input type=\"submit\" value=\"Show Changelog\"></form>\n";

if($r1 && $r2) {

    open(CH, "<changes.t");

    my $show=0;
    if(($r1 eq "CVS") || ($r2 eq "CVS")) {
        $show=1;
        print "<pre>\n";
    }

    while(<CH>) {
        chomp;
        if($_ =~ /Version ([^ ]*)/) {
            my $ver=$1;

            if(($ver eq $r1) || ($ver eq $r2)) {
                $show ^= 1;
                
                if(!$show) {
                     # include the terminating line too
                    print "<span class=\"version\">$_</span>\n";
                    print "</pre>\n";
                    last;
                }
                print "<pre>\n";
            }
            if($show) {
                # show version lines in boldface
                print "<span class=\"version\">$_</span>\n";
            }

        }
        elsif($show) {
            print "$_\n";
        }
    }
    if($show) {
        print "</pre>\n";
    }
    close(CH);  
}

