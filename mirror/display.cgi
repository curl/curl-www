#!/usr/bin/perl

sub showit {
    my $file = $_[0];

    open(FILE, "<$file");
    while(<FILE>) {
        print $_;
    }
    close(FILE);
}

require CGI;

$req = new CGI;

$file = $req->param('file');

print "Content-Type: text/plain\n\n";

showit($file);
