#!/usr/bin/perl

require "CGI.pm";

use strict;
use latest;

my $script="latest.cgi";

require "curl.pm";

my %name;
my %size;
my %download;
my %proto;
my %host;
my %archtype;

my $md5sum="/home/dast/solaris/bin/md5sum";

print "Content-Type: text/html\n\n";

&catfile("head.html");

my $req = new CGI;

my $what=$req->param('curl');

if($what eq "") {
    &where("Download", "/download.html", "Latest Archives");
}
else {
    &where("Download", "/download.html",
           "Latest Archives", "/$script",
           $what);
}

&title("The Most Recent Archives Off the Mirrors");

# check what's available right *now*
&latest::scanstatus();

open(DATA, "<latest.curl");
while(<DATA>) {
    if($_ =~ /^ARCHIVE: ([^:]*): ([^ ]*) (\d*)/) {
        my $type=$1;
        my $archive=$2;
        my $size=$3;

        $name{$type}=$archive;
        $size{$type}=$size;

        $archtype{$archive}=$type;
    }
    elsif($_ =~ /^DOWNLOAD: ([^ ]*) ([^ ]*)/) {
        my $archive=$1;
        my $curl=$2;
        $curl =~ s/\n//g;

        my $proto = uc($curl);

        $proto =~ s/^(FTP|HTTP).*/$1/g;

        my $host = $curl;
        $host =~ s/^(FTP|HTTP):\/\/([^\/]*).*/$2/ig;

        $download{$archive} .= "$curl|||";
        $proto{$curl}=$proto;
        $host{$curl}=$host;
    }
      
}
close(DATA);

sub randomorder {
    my @dl = @_;
    return sort { return int(rand(4)-2); } @_;
}

sub time_ago {
    my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
        $atime,$mtime,$ctime,$blksize,$blocks)
        = stat("latest.curl");

    my $seconds = time - $mtime;

    my $hours=int($seconds/3600);
    my $left=$seconds-$hours*3600;
    if($hours > 2) {
        return sprintf("%d hours and %d minute%s ago", $hours,
                       $left/60,
                       ($left/60)==1?"":"s" );
    }
    if($hours) {
        return sprintf("1 hour and %d minute%s ago",
                       $left/60,
                       ($left/60)==1?"":"s" );
    }
    return sprintf("%d minute%s ago",
                   $left/60,
                   ($left/60)==1?"":"s" );
}

if($latest::version{$what}) {
    my $archive=$name{$what};
            
    my @dl =split('\|\|\|', $download{$archive});
            
    # set to 1 if the local file is newer than the mirrors!
    my $alert=0;
    
    my $desc=$latest::desc{$what};

    if($latest::file{$what} ne $archive) {
        # there's a newer local file!
        $archive=$latest::file{$what};
        $alert = 1;
        $size{$_} = $latest::size{$what};
    }
    my $md5full=`$md5sum "download/$archive"`;
    my ($md5, $file)=split(" ", $md5full);

    print "<h2>$archive</h2>\n";
            
    print "<b>What:</b> $desc\n",
            
    "<br><b>MD5:</b> <tt>".$md5."</tt>\n",
    "<br><b>Size:</b> ".$latest::size{$what}." bytes\n",
    "<br><b>Version:</b> ".$latest::version{$what}."\n";
    
    if($latest::headver ne $latest::version{$what}) {
        print "<p><i>Note that this is </i>not<i> the most recent",
        " release ($latest::headver) of the curl package!</i>";
    }

    if($alert) {
        print "<p>Available from here (verified now):<ul>",
        "<li> <b>HTTP</b> from <b>curl.haxx.se</b> => ",
        "<a href=\"download/$archive\">$archive</a></ul>\n";
    }
    else {
        
        print "<p>Available from these ".($#dl+1)." sites ",
        "(listed in random order, verified ".&time_ago.")\n";
        
        print "<ul>";
        #           for(&randomorder(@dl)) {
        for(@dl) {
            my $url=$_;
            print "<li><b>".$proto{$url}."</b>",
            " from <b>".$host{$url}."</b> => ",
            "<a href=\"$url\">$archive</a>\n";
        }
        print "</ul>\n";
    }
}
elsif($what) {
    print "<p> The <b>recent-version-off-a-mirror</b> system has no info about ",
    "your requested package \"$what\"! :-(\n";
}

print "<p> Select below to see links for other archives:<br>\n";
print "<form method=\"GET\" action=\"latest.cgi\">\n";
print "<select name=\"curl\">\n";
for(sort {$latest::desc{$a} cmp $latest::desc{$b}} keys %latest::desc) {
    my $def;
    if($_ eq $what) {
        $def=" SELECTED";
    }
    else {
        $def="";
    }
    printf("<option value=\"%s\"%s>%s (%s)</option>\n",
           $_, $def, $latest::desc{$_}, $latest::version{$_});
}
print "</select><input type=submit value=\"Gimme a List of Links\"</form>\n";

print "<p> This service automaticly and frequently scans through known",
    " <a href=\"mirrors.html\">mirrors</a> and builds links to the latest",
    " versions of many different curl archives. This page is fine",
    " to bookmark!\n";

&catfile("foot.html");

