#!/usr/bin/perl

require "CGI.pm";
require "ipwhere.pm";

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
my %where;

my $md5sum="/usr/bin/md5sum";
my $sha1sum="sha1sum";

print "Content-Type: text/html\n\n";

my $req = new CGI;

my $what=$req->param('curl');
my $whate=CGI::escapeHTML($what);

my $showall=$req->param('all'); # override geographic checks

my ($mytld, $mycontinent, $mycountry);
my $inmycountry;
my $inmycontinent;

sub otherarchive {

    print "<form method=\"GET\" action=\"$script\">\n";
    print "<p> Select another archive: \n";
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
    print <<MOO

</select><input type=submit value="Show Mirrors"></form>

MOO
;
}

if($what eq "") {
    &header("Archives from Mirrors");

    &where("Download", "/download.html", "Latest Archives");
}
else {
    &header("$what from Mirrors");
    &where("Download", "/download.html",
           "Latest Archives", "/$script",
           $what);
}

&title("The Most Recent Archives Off the Mirrors");

print <<RELATED
<div class="relatedbox">
<b>Related:</b>
<br><a href="changes.html">Changelog</a>
<br><a href="download.html">Download</a>
<br><a href="http://cool.haxx.se/curl-daily/">Daily Snapshot</a>
<br><a href="http://daniel.haxx.se/address.html">GPG Key</a>
</div>

RELATED
    ;


# check what's available right *now*
&latest::scanstatus();

open(DATA, "<latest.curl");
while(<DATA>) {
    chomp; # remove newline
    if($_ =~ /^ARCHIVE: ([^:]*): ([^ ]*) (\d*)/) {
        my $type=$1;
        my $archive=$2;
        my $size=$3;

        $name{$type}=$archive;
        $size{$type}=$size;

        $archtype{$archive}=$type;
    }
    elsif($_ =~ /^DOWNLOAD: ([^ ]*) ([^ ]*) (.*)/) {
        my ($archive, $curl, $where)=($1, $2, $3);

        my $proto = uc($curl);

        $proto =~ s/^(FTP|HTTPS|HTTP).*/$1/g;

        my $host = $curl;
        $host =~ s/^(FTP|HTTPS|HTTP):\/\/([^\/]*).*/$2/ig;

        $download{$archive} .= "$curl|||";
        $proto{$curl}=$proto;
        $host{$curl}=$host;
        $where{$curl}=$where;
    }
      
}
close(DATA);

sub randomorder {
    return sort { return int(rand(4)-2); } @_;
}

sub flag {
    my ($country)=@_;

    my $tld = country2tld($country);

    if($tld) {
        return "<img src=\"/pix/flags/$tld.png\" alt=\"$tld\">";
    }

    return "&nbsp;";
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
    my $md5full=`$md5sum "$latest::dir/$archive"`;
    my ($md5, $file)=split(" ", $md5full);

    my $sha1full=`$sha1sum "download/$archive"`;
    my ($sha1, $dummy)=split(" ", $sha1full);

    print "<h2>$archive</h2>\n";
            
    print "<b>What:</b> $desc\n",
            
    "<br><b>SHA-1:</b> <tt>".$sha1."</tt>\n",
    "<br><b>MD5:</b> <tt>".$md5."</tt>\n",
    "<br><b>Size:</b> ".$latest::size{$what}." bytes\n",
    "<br><b>Version:</b> ".$latest::version{$what}."\n";

    if( -r "download/$archive.asc" ) {
        print "<br><b>GPG signature:</b> <a href=\"download/$archive.asc\">$archive.asc</a>";
    }

    print "<br><br>Download this file with a <span class=\"metalink\"><a href=\"metalink.cgi?curl=$whate\" type=\"application/metalink4+xml\">",
    	  "<img src=\"/pix/metalink.png\" border=\"0\" alt=\"\">metalink</a></span>.<br>\n";

    if($#dl > 10 ) {
        # so many mirrors we show this above them as well
        otherarchive();
    }

    my $myip = $ENV{'REMOTE_ADDR'} || "193.15.23.28";

    ($mytld, $mycontinent, $mycountry) = mycountry($myip);
    #($mytld, $mycontinent, $mycountry) = ("NO", "Oceania", "NORWAY");

    $mycountry = ucfirst(lc($mycountry));

    # print "<p>ME: $tld in $cont\n";
    
    for(@dl) {
        my $url=$_;
        my $flag = country2tld($where{$url});
        my $urlcontinent = tld2continent( $flag );

        if($flag eq lc($mytld)) {
            $inmycountry++;
        }
        if($urlcontinent eq $mycontinent) {
            $inmycontinent++;
        }
    }

    if($latest::headver ne $latest::version{$what}) {
        print "<p><i>Note that this is </i>not<i> the most recent",
        " release ($latest::headver) of the curl package!</i>";
    }

    print "<p><b><tt>$archive</tt></b> is available from\n";
    if($alert) {
        print "(<a href=\"#verified\">verified</a> now):<ul>",
        "<li> <b>HTTP</b> from <b>curl.haxx.se</b> => ",
        "<a href=\"download/$archive\">$archive</a></ul>\n";
    }
    else {
        
        print " ".($#dl+1)." known sites ",
        "(<a href=\"#verified\">verified</a> ".&time_ago.")\n";

        if($showall && ($inmycontinent || $inmycountry)) {
            print "<p> <a href=\"$script?curl=$whate\">Show my closest mirrors</a>";
        }
        elsif($inmycountry) {
            print "<p>$inmycountry of these mirrors are located in ".ucfirst(lc($mycountry))." where it looks like you are located. <a href=\"$script?curl=$whate&amp;all=yes\">Show all mirrors</a>\n";
        }
        elsif($inmycontinent) {
            print "<p>$inmycontinent of these mirrors are located in ".ucfirst(lc($mycontinent))." where it looks like you are located. Showing those mirrors only! <a href=\"$script?curl=$whate&amp;all=yes\">Show all mirrors</a>\n";
        }
        
        print "<table summary=\"List of curl download mirror locations\"><thead><tr class=\"tabletop\">";
        for(('&nbsp;', 'Location', 'Download', 'Proto', 'Host')) {
            print "<th>$_</th>";
        }
        print "</tr></thead><tbody>\n";

        my $i=0;
        for(sort {$where{$a} cmp $where{$b}} @dl) {
            my $url=$_;

            my $flag = flag($where{$url});

            if($showall) {
                ;
            }
            elsif($inmycountry) {
                if(country2tld($where{$url}) ne lc($mytld)) {
                    next;
                }
            }
            elsif($inmycontinent) {
                if(tld2continent( country2tld($where{$url})) ne $mycontinent) {
                    next;
                }
            }

            $i++;
            printf "<tr class=\"%s\"><td>%s</td><td><b>%s</b></td><td><a href=\"%s\">%s</a></td><td>%s</td><td>%s</td></tr>\n",
            $i&1?"odd":"even",
            $flag,
            $where{$url},
            $url,
            $archive,
            $proto{$url},
            $host{$url};
        }
        print "</tbody></table>\n";
    }
}
elsif($what) {
    print "<p> The <b>recent-version-off-a-mirror</b> system has no info about ",
    "your requested package \"$whate\"! :-( This is most likely because there\n",
    "is no up-to-date release for \"$whate\".";
}

otherarchive();

print <<MOO
<h2>Mirroring</h2>
MOO
    ;

if(!$inmycontinent && $mycontinent) {
print <<MOO
<p>

 There is currently <b>no download mirrors in your continent</b> holding this
 package. If this is a new package, there might appear one later on, or we
 hope that <i>you</i> <a href="/mirror/">start hosting a mirror</a> in
 $mycontinent!

MOO
;
}

elsif(!$inmycountry && $mycountry) {
print <<MOO
<p>

 There is currently <b>no download mirrors in your country</b> holding this
 package. If this is a new package, there might appear one later on, or we
 hope that <i>you</i> <a href="/mirror/">start hosting a mirror</a> in
 $mycountry!

MOO
;
}

print <<MOO
<p>
This service automatically and frequently scans through known <a
href="/mirror/">mirrors</a> and builds links to the latest versions of
many different curl archives. This page is fine to bookmark!
The above <a href="http://www.metalinker.org/">Metalink</a> lets you download
this file faster by downloading from several of these mirrors simultaneously,
using the appropriate software.

<h2>Verification of Packages</h2>
<a name="verified"></a>

The script that "verifies" mirrored files only checks if they are present or
not, to verify that you can download them.
<p>

To be really sure and safe that the contents of the files are correct, you
should use the SHA-1 checksum, the MD5 checksum and GPG signature to verify
downloads yourself!

MOO
;

&footer();


