sub title {
    $title=$_[0];
    print "<p>",
    "<table width=100% cellspacing=0 cellpadding=1 bgcolor=\"#000000\"><tr><td>",

    "<table width=100% cellspacing=0><tr><td bgcolor=\"#e0e0ff\">\n",
    "<font color=\"#0000ff\" size=+2>",
    "$title</font></td></tr></table></td></tr></table>";
}

# WHERE2(Feedback, "/feedback/", Bug Report)
sub where {
    my @args = @_;
    my $name;
    my $link;
    my $pic="<img src=\"/arrow.png\">";

    print "<br><a href=\"/\">cURL</a> $pic";
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
    print "</b>";
}

sub catfile {
    open (CAT, $_[0]);
    while(<CAT>) {
        print $_;
    }
    close(CAT);
}


1;
