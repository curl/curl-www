#!/usr/bin/perl

require "/home/dast/perl/date.pm";
require "../dl/pbase.pm";
require "../curl.pm";
require CGI;

require "../latest.pm";

$req = new CGI;

print "Content-Type: text/html\n\n";

my $ua = $ENV{'HTTP_USER_AGENT'};
my $onlyone;
my $sel_os;
my $sel_cpu;
my $sel_flav;

my %typedesc=(
              'devel' => <<MOO

<i> This is for libcurl development - but does not always contain libcurl
itself. Most likely header files and documentation. If you intend to compile
or build something that uses libcurl, this is most likely the package you
want.</i>

MOO
              ,
              'bin' => <<MOO

<i>You will get a pre-built 'curl' binary from this link (or in some cases, by
using the information that is provided at the page this link takes you). You
may or may not get 'libcurl' installed as a shared library/DLL. </i>

MOO
              ,
              'source' => <<MOO

<i>You will not download a pre-built binary from this link. You will instead
get a link to site with the curl source, adjusted for your platform. You will
need to have a compiler setup and working to be able to build curl from a
source package.</i>
MOO
              ,
              'lib' => <<MOO

<i>This is a pure binary libcurl package, possibly including header files and
documentation, but without the command line tool and other cruft. If you want
libcurl for a program that uses libcurl, this is most likely the package you
want.</i>

MOO

              );

my %typelonger = ('bin' => 'curl executable',
                  'devel' => 'libcurl development',
                  'source' => 'source code',
                  'lib' => 'libcurl',
                  '*' => 'Show All');

#print "<h1>$ua</h1>\n";

&header("Download Wizard");
&where("Download", "/download.html", "Download Wizard");
&title("curl Download Wizard");

$database = "../dl/data/databas.db";

my $db=new pbase;
$db->open($database);

my @all = $db->find_all("typ"=>"^entry\$");

printf("<div class=\"relatedbox\">Total number of packages: %d", $#all+1);

for $e (@all) {
    my $o = $$e{'os'};
    $os{$o}++;
}

printf("<br>Number of OSes covered: %d</div>", scalar(keys %os));

print <<MOO

<p> Welcome to the download wizard. This helps you figure out what package to
 download. Proceed and answer the questions below! <a
 href="/download.html">Show all Downloads</a>

MOO
    ;

my $pick_os = CGI::param('os');
my $pick_flav = CGI::param('flav');
my $pick_ver = CGI::param('ver');
my $pick_cpu = CGI::param('cpu');
my $pick_type = CGI::param('type');

my $fl = $pick_flav;
if($pick_flav eq "-") {
    $fl ="";
}

if($pick_type) {
    print <<MOO
<p><a href="./">Restart</a> the Download Wizard!
MOO
;
}

if(0) {
print <<MOO

<div class="quote"><strong> 
The download wizard is still to be seen as a beta application. Please send your
comments and feedback to the curl-users mailing list or to me personally (daniel\@haxx.se).

</strong></div>

MOO
    ;
}
sub selected {
    my ($s) = @_;
    print "<b>$s</b>";
}

sub showsteps {
    my @step=('Package Type', 'OS', 'Flavour',
              'OS Version', 'CPU');
    my $r;
    my $img = " <img alt=\">\" src=\"/arrow.png\"> ";
    my $escos=CGI::escape($pick_os);

    print "<p>";
    for $s (@step) {
        if($r) {
            print "\n".$img;
        }
        $r++;
        if($s eq "Package Type" && $pick_type) {
            print "<a href=\"./\">";
            my $t = $typelonger{$pick_type};
            selected($t?$t:"[invalid]");
            print "</a>";
            next;
        }
        if($s eq "OS" && $pick_os) {
            my $p;
            if($onlyone !~ /os /) {
                print "<a href=\"./?type=$pick_type\">";
                $p="</a>";
            }
            if($pick_os eq "-") {
                selected("Platform Independent");
            }
            else {
                selected("$pick_os");
            }
            print $p;
            next;
        }
        if($s eq "Flavour" && $pick_flav) {
            my $p;
            if($onlyone !~ /flav /) {
                print "<a href=\"./?type=$pick_type&os=$pick_os\">";
                $p="</a>";
            }
            if($pick_flav eq "-") {
                selected("Generic");
            }
            else {
                selected("$pick_flav");
            }
            print $p;
            next;
        }
        if($s eq "OS Version" && $pick_ver) {
            my $p;
            if($onlyone !~ /ver /) {
                print "<a href=\"./?type=$pick_type&os=$pick_os&flav=$pick_flav\">";
                $p="</a>";
            }
            if($pick_ver eq "-") {
                selected("Unspecified Version");
            }
            else {
                selected("$pick_ver");
            }
            print $p;
            next;
        }
        if($s eq "CPU" && $pick_cpu) {
            my $p;
            if($onlyone !~ /cpu /) {
                print "<a href=\"./?type=$pick_type&os=$pick_os&flav=$pick_flav&ver=$pick_ver\">";
                $p="</a>";
            }
            if($pick_cpu eq "-") {
                selected("Any CPU");
            }
            else {
                selected("$pick_cpu");
            }
            print $p;
            next;
        }
    
        print "<font color=\"#f0a0a0\">$s</font>";
    }

    if($pick_cpu) {
  #      print "$img Download!";
    }
}

if(!$pick_type) {
    # no package type yet
    my %type;
    for $e (@all) {
        my $t = $$e{'type'};
        $type{$t}++;
    }

    my $numtype = scalar(keys %type);

    if($numtype == 1) {
        my @t=keys %type;
        $pick_type = $t[0];
        $onlyone .= "type ";
    }
    else {
        showsteps();

        subtitle("Select Type of Package");

        print "<p> We provide packages of different types. Select one (or select 'show all' to view all types)";

        for(sort keys %type) {
            print "<blockquote><a href=\"./?type=$_\">".$typelonger{$_}."</a> - ".$typedesc{$_}."</blockquote>";
        }
        print "<blockquote><a <a href=\"./?type=*\">Show All</a> - Display all known package types.</blockquote>";

    }

}

if($pick_type && !$pick_os) {

    if($ua =~ /(windows|win32|Win98|Win95|WinNT)/i) {
        $sel_os = "Win32";
    }
    elsif($ua =~ /Linux/i) {
        $sel_os = "Linux";
    }
    elsif($ua =~ /IRIX/i) {
        $sel_os = "IRIX";
    }
    elsif($ua =~ /(SunOS|Solaris)/i) {
        $sel_os = "Solaris";
    }
    elsif($ua =~ /BeOS/i) {
        $sel_os = "BeOS";
    }
    elsif($ua =~ /QNX/i) {
        $sel_os = "QNX";
    }
    elsif($ua =~ /HP-UX/i) {
        $sel_os = "HPUX";
    }
    elsif($ua =~ /FreeBSD/i) {
        $sel_os = "FreeBSD";
    }
    elsif($ua =~ /NetBSD/i) {
        $sel_os = "NetBSD";
    }
    elsif($ua =~ /OpenBSD/i) {
        $sel_os = "OpenBSD";
    }
    elsif($ua =~ /AIX/i) {
        $sel_os = "AIX";
    }
    elsif($ua =~ /Amiga/i) {
        $sel_os = "AmigaOS";
    }
    elsif($ua =~ /Mac/i) {
        $sel_os = "Mac OS X";
    }
    elsif($ua =~ /RISC OS/i) {
        $sel_os = "RISC OS";
    }
    elsif($ua =~ /SymbianOS|Symbian OS/i) {
        $sel_os = "Symbian OS";
    }
    elsif($ua =~ /OSF1/i) {
        $sel_os = "Tru64";
    }
    elsif($ua =~ /VMS/i) {
        $sel_os = "VMS";
    }
    elsif($ua =~ /DOS/i) {
        $sel_os = "DOS";
    }
    elsif($ua =~ /OS\/2/i) {
        $sel_os = "OS/2";
    }
    elsif($ua =~ /Indy Library/i) {     # Windows-only client library
        $sel_os = "Win32";
    }
    elsif($ua =~ /(Lynx|w3m|Dillo|MMM|Grail|Mosaic|amaya|Konqueror|Links)/i) {
        $sel_os = "Linux"; # we don't know these are Linux, we just guess
    }
    elsif($ua =~ /(Python-urllib|Wget|lwp)/i) {
        $sel_os = "no idea"; # automated agents
    }

    if(!$sel_os && $ua) {
        print "<p><b>Beta Alert! We couldn't detect your OS, please inform me (daniel\@haxx.se) and include this User-Agent string in the report: \"$ua\"</b><p>";
    }

    #print "<p> If you want a curl package for the OS you are currently using, you want a package for <b>$sel_os</b>";
    
    my $c;
    my %os;
    for $e (@all) {
        if((($pick_type eq "*") || ($$e{'type'} eq $pick_type))) {
            $os{$$e{'os'}}++;
        }
    }

    my $numos = scalar(keys %os);
    if($numos == 0 ) {
        showsteps();
        print "<p> Internal error: We found no operating systems for the given package type: $pick_type";
    }
    elsif($numos == 1 ) {
        my @o =keys %os;
        $pick_os = $o[0];
        $onlyone .= "os ";
    }
    else {

        showsteps();

        subtitle("Select Operating System");

        print "<form action=\"./\" method=\"GET\">\n",
        "<input type=\"hidden\" name=\"type\" value=\"$pick_type\">\n",
        "Show package for: <select onChange=\"submit();\" name=\"os\">\n";
        for(sort keys %os) {
            my $s;

            if($sel_os eq $_) {
                $s=" SELECTED";
            }
            my $show = $_;
            if($_ eq "-") {
                $show = "Platform Independent";
            }
            elsif($_ eq "Win32") {
                $show = "Windows / Win32";
            }
        
            print "<option$s value=\"$_\">$show</option>\n";
        }
        print "</select>",
        "<input type=\"submit\" value=\"Select!\">",
        "</form>";

        print <<MOO

<p><i> If you miss an operating system in this listing, it is most likely
because we don\'t know any packages of your selected type for that operating
system.</i>
            
MOO
;
    }
}

if(!$pick_flav && $pick_os && $pick_type) {
    # An OS is picked but a flavour has not been picked

    my %flav;
    for $e (@all) {
        if(($$e{'os'} eq $pick_os) &&
           (($pick_type eq "*") || ($$e{'type'} eq $pick_type))) {
            my $f = $$e{'flav'};
            $flav{$f}++;
        }
    }

    my $numflav = scalar(keys %flav);
    
    if($numflav == 0) {
        showsteps();

        print "<p> Internal error: We found no flavour at all for $pick_os";
    }
    elsif($numflav == 1) {
        my @f=keys %flav;
        $pick_flav = $f[0];
        if($pick_flav ne "-") {
            $fl = $pick_flav;
        }
        $onlyone .= "flav ";
    }
    else {
        $sel_flav = "";
        if($ua =~ /mdk/i) {
            $sel_flav = "Mandrake";
        }
        elsif($ua=~ /Debian/i) {
            $sel_flav = "Debian";
        }
        elsif($ua=~ /gentoo/i) {
            $sel_flav = "Gentoo";
        }
        elsif($ua=~ /cygwin/i) {
            $sel_flav = "cygwin";
        }

        showsteps();

        subtitle("Select for What Flavour");

        printf ("<p> We have %s packages listed for %d different flavours of <b>$pick_os</b>.",
                $pick_type eq "*"?"":"<b>".$typelonger{$pick_type}."</b>",
                $numflav);

        print "<form action=\"./\" method=\"GET\">\n",
        "<input type=\"hidden\" name=\"type\" value=\"$pick_type\">",
        "<input type=\"hidden\" name=\"os\" value=\"$pick_os\">",
        "Show package for: <select onChange=\"submit();\" name=\"flav\">\n";
        for(sort keys %flav) {
            my $show = $_;
            my $s;
            if($_ eq "-") {
                $show = "Generic";
            }
            if($sel_flav eq "$_") {
                $s = " SELECTED";
            }
            print "<option$s value=\"$_\">$show</option>\n";
        }
        print "</select>",
        "<input type=\"submit\" value=\"Select!\">",
        "</form>";
    }
}

if($pick_os && $pick_flav && !$pick_ver) {
    my %ver;
    for $e (@all) {
        if(($$e{'os'} eq $pick_os) &&
           (($pick_type eq "*") || ($$e{'type'} eq $pick_type)) &&
           ($$e{'flav'} eq $pick_flav)) {
            my $v = $$e{'osver'};
            $ver{"$v"}++;
        }
    }

    my $numver = scalar(keys %ver);

    if($numver == 0) {
        showsteps();

        print "<p> Internal error: We found no version at all for $pick_flav";
    }
    elsif($numver == 1) {
        my @v=keys %ver;
        $pick_ver = $v[0];
        $onlyone .= "ver ";
    }
    else {
        showsteps();

        subtitle("Select which $fl $pick_os Version");

        printf ("<p> We have packages listed for %d different versions of <b>$fl $pick_os</b>.",
                $numver);

        print "<form action=\"./\" method=\"GET\">\n",
        "<input type=\"hidden\" name=\"type\" value=\"$pick_type\">",
        "<input type=\"hidden\" name=\"os\" value=\"$pick_os\">",
        "<input type=\"hidden\" name=\"flav\" value=\"$pick_flav\">",
        "Show package for <b>$fl $pick_os</b> version: ",
        "<select onChange=\"submit();\" name=\"ver\">\n";
        for(sort keys %ver) {
            my $show = $_;
            if($_ eq "-") {
                $show = "Unspecified";
            }
            print "<option value=\"$_\">$show</option>\n";
        }
        print "</select>",
        "<input type=\"submit\" value=\"Select!\">",
        "</form>";
    }
}

if($pick_os && $pick_flav && $pick_ver && !$pick_cpu) {
    my %cpu;
    for $e (@all) {
        if( ($$e{'os'} eq $pick_os) &&
            (($pick_type eq "*") || ($$e{'type'} eq $pick_type)) &&
            ($$e{'flav'} eq $pick_flav) &&
            ($$e{'osver'} eq $pick_ver) ) {
            my $c = $$e{'cpu'};
            $cpu{$c}++;
        }
    }

    my $numcpu = scalar(keys %cpu);

    if($numcpu == 0) {
        showsteps();
        print "<p>Internal error: We found no CPUs at all for this version of this OS!";
    }
    elsif($numcpu == 1) {
        my @c = (keys %cpu);
        $pick_cpu = $c[0];
        $onlyone .= "cpu ";
    }
    else {
        $sel_cpu = "i386"; # naive default assumption
        if($ua =~ /(Mac|PPC)/i) {
            $sel_cpu = "PPC";
        }
        elsif($ua =~ /sun4|sparc/i) {
            $sel_cpu = "Sparc";
        }
        elsif($ua =~ /ia64/i) {
            $sel_cpu = "ia64";
        }
        elsif($ua =~ /x86_64|athlon|AMD64/i) {
            $sel_cpu = "x86_64";
        }
        elsif($ua =~ /alpha/i) {
            $sel_cpu = "Alpha";
        }
        elsif($ua =~ /arm/i) {
            $sel_cpu = "StrongARM";
        }

        my $ver=$pick_ver;
        if($ver eq "-") {
            $ver = "";
        }
        showsteps();

        subtitle("Select for What CPU");

        printf ("<p> We have packages listed for %d different CPUs for <b>$fl $pick_os $ver</b>.",
                $numcpu);

        print "<form action=\"./\" method=\"GET\">\n",
        "<input type=\"hidden\" name=\"type\" value=\"$pick_type\">",
        "<input type=\"hidden\" name=\"os\" value=\"$pick_os\">",
        "<input type=\"hidden\" name=\"flav\" value=\"$pick_flav\">",
        "<input type=\"hidden\" name=\"ver\" value=\"$pick_ver\">",
        "Show package for <b>$fl $pick_os $ver</b> on",
        " <select onChange=\"submit();\" name=\"cpu\">\n";
        for(sort keys %cpu) {
            my $show = $_;
            my $s;
            if($_ eq "-") {
                $show = "CPU Independent";
            }
            if($sel_cpu eq "$_") {
                $s = " SELECTED";
            }
            print "<option$s value=\"$_\">$show</option>\n";
        }
        print "</select>",
        "<input type=\"submit\" value=\"Select!\">",
        "</form>";
    }
}

sub single {
    my ($e) = @_;

    my $t=$$e{'type'};
    my $file=$$e{'file'};
    my $show=$file;
    my $ssl=$$e{'ssl'} eq "No"?"no":"";
    my $sslenable=$$e{'ssl'} eq "No"?"disabled":"enabled";
    my $mirror=$$e{'re'} ne "-"?"<a href=\"http://curl.haxx.se/latest.cgi?curl=$$e{'re'}\">mirrored versions</a>":"";
    my $pack=$$e{'pack'};
    my $aboutver;
    my $version=$$e{'curl'};
    my $provided = $$e{'name'} ne "-"?"<br>Provided by: $$e{'name'}":"";

    # check what's available right *now*
    &latest::scanstatus();

    if($latest::headver ne $version) {
        my $premail;
        my $postmail;
        my $em = $$e{'email'};
        my $name = $$e{'name'};
        my $maint;
        if($name && $name ne "-") {
            $maint = "($name) ";
        }
        if($em && ($em ne "-")) {
            if($em =~ /:\/\//) {
                # plain URL
                $premail="<a href=\"$em\">";
            }
            elsif(($em =~ /\@/) && ($em !~ /^mailto:/)) {
                # email address
                $premail="<a href=\"mailto:$em\">";
            }
            $postmail="</a>";
        }
        $aboutver = <<MOO

<p>This package is <b>not</b> built from the latest version available. This is
version <b>$version</b> while the latest source available has version
<b>$latest::headver</b>. This might be OK for you. If not, ${premail}contact
the maintainer of this package ${maint}and ask kindly for an
update${postmail}. Or get a 'source' package and build a newer one yourself.

MOO
;
    }
    
    my $l=length($show);
    if($l > 50) {
        $show = substr($show, 0, 35)."...".substr($show, $l-15);
    }

    if($file !~ /\/\//) {
        $file="/download/$file";
    }

    print <<MOO
<p>
<div class="quote">
<div class="yellowbox">
<a href="$file"><img align="right" src="download.gif" border="0" width="100" height="30"></a>
curl version: $version <img src="/${ssl}ssl.png"> (SSL $sslenable)
<br>URL:&nbsp;<a href="$file">$show</a> $mirror
$provided
</div>
MOO
;
    print "<p> This package is type <b>".$typelonger{$t}."</b>".$typedesc{$t};
    print $aboutver;

    if($pack ne "-") {
        print "<p> The file is packaged using <b>$pack</b>.";
    }

    if($pack eq "zip") {
        print " Zip is a widely-used compression format. <a href=\"http://en.wikipedia.org/wiki/ZIP_file_format\">Wikipedia has more details on zip</a>.";
    }
    elsif($pack eq "tar+gz") {
        print " This file is tar'ed and then gzipped. <a href=\"http://en.wikipedia.org/wiki/Gzip\">Wikipedia has more details on gzip</a>.";
    }
    elsif($pack eq "tar+bz2") {
        print " This file is tar'ed and then bzip2ed. <a href=\"http://en.wikipedia.org/wiki/Bzip2\">Wikipedia has more details on bzip2</a>.";
    }
    elsif($pack eq "tar+Z") {
        print " This file is tar'ed and then compressed. <a href=\"http://en.wikipedia.org/wiki/Compress\">Wikipedia has more details on compress</a>.";
    }
    elsif($pack eq "lha") {
        print " Lha is a common freeware compression utility on Amiga. <a href=\"http://en.wikipedia.org/wiki/LHA_%28file_format%29\">Wikipedia has more details on lha</a>.";
    }
    elsif($pack eq "pkg") {
        print " pkg is a file format and tools collection made to handle software installation for your system.";
    }
    elsif($pack eq "RPM") {
        print " RPM is a file format and tools collection made to handle software installation for a range of different Linux systems. <a href=\"http://en.wikipedia.org/wiki/RPM_Package_Manager\">Wikipedia has more details on RPM</a>";
    }
    elsif($pack eq "deb") {
        print " deb is a file format with accompanying tools collection made to handle software installation for Debian Linux (and derivates). <a href=\"http://en.wikipedia.org/wiki/Deb_%28file_format%29\">Wikipedia has more details on deb</a>";
    }

    print "</div>";

    return $t;
}


sub sortent {
    my $ret = $$a{'type'} cmp $$b{'type'};
    if(!$ret) {
        $ret = $$b{'curl'} cmp $$a{'curl'};
    }
    return $ret;
}
if($pick_os && $pick_flav && $pick_ver && $pick_cpu) {
 #   print "<p>WANT: OS ($pick_os) FLAV ($pick_flav) VER ($pick_ver) CPU ($pick_cpu)";

    showsteps();

    subtitle("The Wizard Recommends...");

    my $ver=$pick_ver;
    if($ver eq "-") {
        $ver = "";
    }
    my $os=$pick_os;
    if($os eq "-") {
        $os = "Platform Independent";
    }
    my $img;

    my @match;
    for $e (@all) {
        if( ($$e{'os'} eq $pick_os) &&
            (($pick_type eq "*") || ($$e{'type'} eq $pick_type)) &&
            ($$e{'flav'} eq $pick_flav) &&
            ($$e{'osver'} eq $pick_ver) &&
            ($$e{'cpu'} eq $pick_cpu)) {

            push @match, $e;

            if($$e{'img'}) {
                $img = $$e{'img'};
            }
        }
    }

    if($img) {
        printf("<img src=\"/pix/%s\" align=\"right\">", $img);
    }
    if($fl eq "-") {
        $fl = "";
    }
    printf( "<p>For <b>$fl $os $ver%s %s</b>",
            $pick_cpu ne "-"?" on $pick_cpu":"(CPU Independent)",
            $pick_type ne "*"?" ".$typelonger{$pick_type}:"");
    
    my %got;
    my $type;
    if(scalar(@match) == 0) {
        # no match!
        
        print "<p> Internal error. Found no matching entries.";
    }

    elsif(scalar(@match) == 1) {
        my $e=$match[0];

        $type = single($e);
        $got{$type}++;
    }
    else {
        # more than one found!
        my $i;
        for $e (sort sortent @match) {
            $type = single($e);
            $got{$type}++;
        }
    }

    if($onlyone) {
        my @w = split(" ", $onlyone);
        my $v = $pick_ver;
        my $f = $pick_flav;
        my $o = $pick_os;
        if($o eq "-") {
            $o = "Platform Independent";
        }
        if($f eq "-") {
            $f = "generic";
        }
        if($v eq "-") {
            $v = "unspecified";
        }
        for $e (@w) {
            if($e eq "os") {
                my $o = $pick_os;
                print "<p> We know only one OS ($pick_os) for ";
                selected("package ".$typelonger{$pick_type});
            }
            elsif($e eq "flav") {
                if($pick_os ne "-") {
                    print "<p> We know only one flavour ($f) of ";
                    selected($o);
                    print " for ";
                    selected("package ".$typelonger{$pick_type});
                }
            }
            elsif($e eq "ver") {
                if($pick_os ne "-") {
                    print "<p> We know only one OS version ($v) for ";
                    selected("package ".$typelonger{$pick_type}." on $fl $pick_os");
                }
            }
            elsif($e eq "cpu") {
                if($pick_os ne "-") {
                    my $c = $pick_cpu;
                    if($c eq "-") {
                        $c = "CPU Independent/unknown";
                    }
                    print "<p> We know only one CPU ($c) for ";
                    selected("package ".$typelonger{$pick_type}." on $fl $pick_os version $v");
                }
            }
        }
    }


}
&catfile("../foot.html");
