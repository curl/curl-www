
our $root="/userdir/dast/curl_html";

sub stitle {
    my ($title)=@_;
    return "<h1 class=\"pagetitle\">$title</h1>";
}

sub title {
    my $title=$_[0];
    print stitle($title);
}

sub subtitle {
    my $title=$_[0];
    print "<h2>$title</h2>";
}

# WHERE2(Feedback, "/feedback/", Bug Report)
sub where {
    my @args = @_;
    my $name;
    my $link;
    my $pic="<img alt=\">\" src=\"/arrow.png\">";

    print "<a href=\"/\">cURL</a> $pic";
    while(1) {
        $name = shift @args;
        $link = shift @args;
        if($name) {
            # things look ok
            if($link) {
                print " <a href=\"$link\">$name</a> $pic";
            }
            else {
                print " <b>$name</b>";
            }
        }
        else {
            last; # get out of loop
        }
    }
}

sub catfile {
    open (CAT, $_[0]);
    while(<CAT>) {
        print $_;
    }
    close(CAT);
}

# <pre>-print a file, convert <> to HTML
sub precatfile {
    open (CAT, $_[0]);
    print "<pre>\n";
    while(<CAT>) {
        $_ =~ s/</&lt;/g;
        $_ =~ s/>/&gt;/g;
        print "$_";
    }
    close(CAT);
    print "</pre>\n";
}

sub header {
    my ($head)=@_;

    open(HEAD, "<$root/head.html");
    while(<HEAD>) {
        $_ =~ s/\<title\>cURL\<\/title\>/<title>cURL: $head<\/title>/;
        print $_;
    }
    close(HEAD);
}

sub footer {
    open(FOOT, "<$root/foot.html");
    while(<FOOT>) {
        print $_;
    }
    close(FOOT);
}

1;
