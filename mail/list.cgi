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

    return "http://cool.haxx.se/mailman/listinfo/curl-users";
}


sub libcurl {
    my ($num)=@_;

    my $some_dir=".";
    opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
    my @dirs = sort {$a cmp $b} grep { /^lib-/ && -d "$some_dir/$_" } readdir(DIR);
    closedir DIR;

    &showarchs($num, @dirs);

    # return subscription URL
    return "http://cool.haxx.se/mailman/listinfo/curl-library";
}

sub curlphp {

    my ($num)=@_;

    my $some_dir=".";
    opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
    my @dirs = sort {$a cmp $b} grep { /^curlphp-/ && -d "$some_dir/$_" } readdir(DIR);
    closedir DIR;

    &showarchs($num, @dirs);

    # return subscription URL
    return "http://cool.haxx.se/mailman/listinfo/curl-and-php";
}

if($list) {
    my $subscr;

    &catfile("../head.html");

    &where("Mailing Lists", "http://curl.haxx.se/mail/", "$list archive");

    &title("$list Archives");

print <<MOO
<p>
This is the complete web archive of all stored mails ever posted to this
mailing list.

MOO
    ;

    if(($list eq "curl-main") ||
       ($list eq "curl-users")) {
        $subscr = curlmain();
    }
    elsif($list eq "curl-library") {
        $subscr = libcurl();
    }
    elsif($list eq "curl-and-php") {
        $subscr = curlphp();
    }
    else {
        print "$list? Are you playing with me? There's no such list!";
    }

    if($subscr) {
        &title("Subscribe to $list");
        print "<p> To subscribe on $list, use the web form on this page: <a href=\"$subscr\">subcribe to $list</a>";
    }

    &title("Other Mail Archives");

    my @archs=('curl-users',
               'curl-library',
               'curl-and-php');

    for(@archs) {
        my $this=$_;
        if($list ne $this) {
            print "<p><a href=\"list.cgi?list=$this\">$this</a>\n";
        }
    }

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

print "<p><b>curl-users mailing list:</b>\n";
&curlmain(4);
print "<p><a href=\"list.cgi?list=curl-users\">full curl-users archive</a></td><td bgcolor=\"#e0e0e0\" width=33%>\n";

print "<p><b>curl-library mailing list:</b>\n";
&libcurl(4);
print "<p><a href=\"list.cgi?list=curl-library\">full curl-library archive</a></td><td width=33%>\n";

print "<p><b>curl-and-php mailing list:</b>\n";
&curlphp(4);
print "<p><a href=\"list.cgi?list=curl-and-php\">full curl-and-php archive</a></td></tr></table>\n";

&catfile("../foot.html");
print "</body></html>\n";
