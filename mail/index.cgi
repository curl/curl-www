#!/usr/local/bin/perl

require "/home/dast/perl/date.pm";
require "../curl.pm";
require CGI;

$req = new CGI;

my $list = $req->param('list');

print "Content-Type: text/html\n\n";

sub showarchs {
    my ($num, @dirs) = @_;

    my %years;

    if($num > 0) {
        while(scalar(@dirs) > $num) {
            shift @dirs;
        }
    }

    for(@dirs) {
        if($_ =~ /(\d\d\d\d)-(\d\d)/) {
            $years{$1}=1;
        }
    }

    @syears = sort { $b <=> $a } keys %years;
    
    for(@syears) {
        $thisyear=$_;
        my $pr=0;

        for(@dirs) {
            if($_ =~ /(\d\d\d\d)-(\d\d)/) {
                $year=$1;
                $mon=$2;
                
                if($thisyear == $year) {
                    if(!$pr++) {
                        print "<p><b>Year $thisyear</b><br>\n";
                    }
                    print "<a href=\"$_/\">".&MonthNameEng($2)."</a> \n";
                }
            }
        }
    }

}

sub curlmain {
    my ($num)=@_;

    my $some_dir=".";
    opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
    my @dirs = sort {$a cmp $b} grep { /^archive-/ && -d "$some_dir/$_" } readdir(DIR);
    closedir DIR;

    &showarchs($num, @dirs);

    if($num <= 0 ) {
        print "<p><b>Year 1999</b><br>\n";

        print " <a href=\"archive_pre_oct_99/\">August - September</a>\n",
        "<br> <a href=\"archive/\">October - December</a>",
        "\n";
    }
}


sub libcurl {
    my ($num)=@_;

    my $some_dir=".";
    opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
    my @dirs = sort {$a cmp $b} grep { /^lib-/ && -d "$some_dir/$_" } readdir(DIR);
    closedir DIR;

    &showarchs($num, @dirs);

}

sub curlphp {

    my ($num)=@_;

    my $some_dir=".";
    opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
    my @dirs = sort {$a cmp $b} grep { /^curlphp-/ && -d "$some_dir/$_" } readdir(DIR);
    closedir DIR;

    &showarchs($num, @dirs);
}

if($list) {
    &catfile("../head.html");
    &title("$list Archives");

print <<MOO
<p>
This is the complete web archive of all stored mails ever posted to this
mailing list.

MOO
    ;

    if($list eq "curl-main") {
        curlmain();
    }
    elsif($list eq "curl-library") {
        libcurl();
    }
    elsif($list eq "curl-and-php") {
        curlphp();
    }
    else {
        print "$list? Are you playing with me? There's no such list!";
    }

    &title("Other Mail Archives");

    my @archs=('curl-main',
               'curl-library',
               'curl-and-php');

    print "<p>";

    for(@archs) {
        my $this=$_;
        if($list ne $this) {
            print "<a href=\"./?list=$this\">$this</a>\n";
        }
    }
    print "<p> <a href=\"./\">Mailing List Main Page</a>\n";

    &catfile("../foot.html");
    print "</body></html>\n";
    exit;
}


&catfile("mail.html");
&title("Mailing List Archives");

print <<MOO
Links to the last couple of months\' archives are here, press the "full
archive" links to see the whole archives.
MOO
    ;

print "<p><table cellspacing=3 cellpadding=10 border=3><tr valign=top><td width=33%>\n";

print "<p><b>Main mailing list:</b>\n";
&curlmain(4);
print "<p><a href=\"./?list=curl-main\">full curl-main archive</a></td><td bgcolor=\"#e0e0e0\" width=33%>\n";

print "<p><b>Libcurl mailing list:</b>\n";
&libcurl(4);
print "<p><a href=\"./?list=curl-library\">full curl-library archive</a></td><td width=33%>\n";

print "<p><b>curl-and-php mailing list:</b>\n";
&curlphp(4);
print "<p><a href=\"./?list=curl-and-php\">full curl-and-php archive</a></td></tr></table>\n";

&catfile("../foot.html");
print "</body></html>\n";
