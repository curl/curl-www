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
my %where;

my $md5sum="md5sum";#/home/dast/solaris/bin/md5sum";

print "Content-Type: text/html\n\n";

my $req = new CGI;

my $what=$req->param('curl');

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

        $proto =~ s/^(FTP|HTTP).*/$1/g;

        my $host = $curl;
        $host =~ s/^(FTP|HTTP):\/\/([^\/]*).*/$2/ig;

        $download{$archive} .= "$curl|||";
        $proto{$curl}=$proto;
        $host{$curl}=$host;
        $where{$curl}=$where;
    }
      
}
close(DATA);

sub randomorder {
    my @dl = @_;
    return sort { return int(rand(4)-2); } @_;
}

sub flag {
    my ($country)=@_;
    my $tld;

    if($country =~ /Australia/) {
        $tld="au";
    }
    elsif($country =~ /Austria/) {
        $tld="at";
    }
    elsif($country =~ /Denmark/) {
        $tld="dk";
    }
    elsif($country =~ /Estonia/) {
        $tld="ee";
    }
    elsif($country =~ /France/) {
        $tld="fr";
    }
    elsif($country =~ /Germany/) {
        $tld="de";
    }
    elsif($country =~ /Greece/) {
        $tld="gr";
    }
    elsif($country =~ /Hong Kong/) {
        $tld="hk";
    }
    elsif($country =~ /Russia/) {
        $tld="ru";
    }
    elsif($country =~ /Sweden/) {
        $tld="se";
    }
    elsif($country =~ /Thailand/) {
        $tld="th";
    }
    elsif($country =~ /US/) {
        $tld="us";
    }
    elsif($country =~ /Taiwan/) {
        $tld="tw";
    }

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
    my $md5full=`$md5sum "download/$archive"`;
    my ($md5, $file)=split(" ", $md5full);

    print "<h2>$archive</h2>\n";
            
    print "<b>What:</b> $desc\n",
            
    "<br><b>MD5:</b> <tt>".$md5."</tt>\n",
    "<br><b>Size:</b> ".$latest::size{$what}." bytes\n",
    "<br><b>Version:</b> ".$latest::version{$what}."\n";
    
    if( -r "download/$archive.asc" ) {
        print "<br><b>GPG signature:</b> <a href=\"download/$archive.asc\">$archive.asc</a>";
    }
    
    if($latest::headver ne $latest::version{$what}) {
        print "<p><i>Note that this is </i>not<i> the most recent",
        " release ($latest::headver) of the curl package!</i>";
    }

    if($alert) {
        print "<p>Available from here (<a href=\"#verified\">verified</a> now):<ul>",
        "<li> <b>HTTP</b> from <b>curl.haxx.se</b> => ",
        "<a href=\"download/$archive\">$archive</a></ul>\n";
    }
    else {
        
        print "<p>Available from these ".($#dl+1)." sites ",
        "(<a href=\"#verified\">verified</a> ".&time_ago.")\n";
        
        print "<table><tr>";
        for(('Flag', 'Where', 'Proto', 'Host', 'File')) {
            print "<th>$_</th>";
        }
        print "</tr>\n";

        my $i=0;
        for(sort {$where{$a} cmp $where{$b}} @dl) {
            my $url=$_;

            my $flag = flag($where{$url});

            $i++;
            printf "<tr class=\"%s\"><td>%s</td><td><b>%s</b></td><td>%s</td><td>%s</td><td><a href=\"%s\">%s</a></td></tr>\n",
            $i&1?"odd":"even",
            $flag,
            $where{$url},
            $proto{$url},
            $host{$url},
            $url,
            $archive;
        }
        print "</table>\n";
    }
}
elsif($what) {
    print "<p> The <b>recent-version-off-a-mirror</b> system has no info about ",
    "your requested package \"$what\"! :-( This is most likely because there\n",
    "is no up-to-date release for \"$what\".";
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
print <<MOO

</select><input type=submit value="Gimme a List of Links"></form>

<p> This service automatically and frequently scans through known <a
href="mirrors.html">mirrors</a> and builds links to the latest versions of
many different curl archives. This page is fine to bookmark!

<h2>Verification of Mirrored Packages</h2>
<a name="verified"></a>

The script that "verifies" mirrored files only checks if they are present or
not, to verify that you can download them.
<p>

To be really sure and safe that the contents of the files are correct, you
should use the MD5 checksum and GPG signature to verify downloads yourself!

MOO
;

&footer();


