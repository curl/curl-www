#!/usr/bin/perl

require "../date.pm";
require "../curl.pm";
require CGI;

$req = new CGI;

my $list = $req->param('list');
my $full = $req->param('full');

# only keep legit list name letters
$list =~ s/([^a-z-]+)//g;

print "Content-Type: text/html\n\n";

sub showarchs {
    my (@dirs) = @_;

    my %years;

    for(@dirs) {
        if($_ =~ /(\d\d\d\d)-(\d\d)/) {
            $years{$1}=1;
        }
    }

    @syears = sort { $b <=> $a } keys %years;
    
    print "<table cellspacing=\"3\">\n";

    my $i=0;

    for(@syears) {
        my $year=$_;
        my $pr=0;
        my $mon;

        print "<tr><td><b>$year</b></td>\n";

        foreach $m (01 .. 12) {
            my $mon = sprintf("%02d", $m);
            my $f;
            foreach $d (@dirs) {
                if($d =~ /$year-$mon$/) {
                    $f=$d;
                    last;
                }
            }
            if($f) {
                print "<td><a href=\"$f/\">".substr(&MonthNameEng($mon), 0, 3)."</a></td>\n";
            }
            else {
                print "<td>&nbsp;</td>";
            }
        }
        print "</tr>\n";

        if((++$i > 3 && ($full < 1))) {
            last;
        }
    }
    print "</table>\n";

}

sub listarchives {
    my ($prefix, $listname)=@_;

    my $some_dir=".";
    opendir(DIR, $some_dir) || die "can't opendir $some_dir: $!";
    my @dirs = sort {$a cmp $b} grep { /^$prefix-/ && -d "$some_dir/$_" } readdir(DIR);
    closedir DIR;

    &showarchs(@dirs);

    return "https://cool.haxx.se/mailman/listinfo/$listname";
}

if($list) {
    my $subscr;
    my $none;

    &header("The $list archive");

    &where("Mailing Lists", "https://curl.haxx.se/mail/", "$list archive");

    &title("The $list archive");

print <<MOO
<div class="relatedbox">
<b>Related:</b>
<br><a href="/mail/etiquette.html">Mailing List Etiquette</a>
</div>

MOO
    ;

    if($list eq "curl-users") {
        $subscr = listarchives("archive", "curl-users");
    }
    elsif($list eq "curl-library") {
        $subscr = listarchives("lib", "curl-library");
    }
    elsif($list eq "curl-and-php") {
        $subscr = listarchives("curlphp", "curl-and-php");
    }
    elsif($list eq "curl-and-python") {
        $subscr = listarchives("curlpython", "curl-and-python");
    }
    elsif($list eq "curl-tracker") {
        $subscr = listarchives("tracker", "curl-tracker");
    }
    elsif($list eq "curl-meet") {
        $subscr = listarchives("meet", "curl-meet");
    }
    elsif(($list eq "curl-announce") ||
          ($list eq "curl-www-commits") ||
          ($list eq "curl-commits")) {
        $subscr = "https://cool.haxx.se/cgi-bin/mailman/listinfo/$list";
        print "There is no archive of this list.";
        $none=1;
    }
    else {
        print "$list? Are you playing with me? There's no such list!";
        $none=1;
    }

    if(!$none) {
        if($full < 1) {
            print "<p> This is the last few years of mails posted to the <b>$list</b> mailing list. See <a href=\"list.cgi?list=$list&amp;full=1\">full archive</a>.";
        }
        else {
            print "<p> This is the entire archive of mails posted to the <b>$list</b> mailing list. See <a href=\"list.cgi?list=$list\">recent archive</a> only.";
        }

    }

    if($subscr) {
        &subtitle("Subscribe to $list");
        print "<p> <a href=\"$subscr\">subcribe to $list</a>";
    }

    &title("More Mailing Lists");

    my @archs=('curl-users',
               'curl-library',
               'curl-and-php',
               'curl-and-python',
               'curl-meet');

    my $n;
    for(@archs) {
        my $this=$_;
        if($list ne $this) {
            printf("%s<a href=\"list.cgi?list=$this\">$this</a>",
                   $n?", ":"");
            $n++;
        }
    }

    &title("Search This Site (and the mailing lists)");

    &catfile("../sitesearch.t");

    &catfile("../foot.html");
    print "</body></html>\n";
    exit;
}


&catfile("mail.html");
&catfile("../foot.html");

