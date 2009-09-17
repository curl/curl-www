#!/usr/bin/perl

sub showit {
    my $file = $_[0];

    if(open(FILE, "<$file")) {
        
        while(<FILE>) {
            print $_;
        }
        close(FILE);
    }
    else {
        print "bad file";
    }
}

require CGI;

$req = new CGI;

$file = $req->param('file');

$file =~ s/\.\.//g;
$file =~ s:\/::g;

print "Content-Type: text/plain\n\n";

if(length($file) < 3) {
    print "bluerg\n";
    exit;
}

showit($file);
