
require "../curl.pm";

$adminpasswd="ninja";

# -----------------------------
# Make the suggestion look better. Cut off all HTML, then add our HTML!
sub cleantext {
    my $idea = $_[0];
    my $html = $_[1]; # non-zero if we allow converted HTML

    # replace & with html-text
    $idea =~ s/&/&amp;/g;

    # convert < and > first
    $idea =~ s/</&lt;/g;
    $idea =~ s/>/&gt;/g;

    if($html) {

        # insert <p> to make new paragraphs
        $idea =~ s/\r\n\r\n/\r\n<p>\r\n/g;

        # we add rel=\"nofollow\" to stop Google from following links:
        # http://googleblog.blogspot.com/2005/01/preventing-comment-spam.html

        # replace http://-specified URLs
        $idea =~ s/(http:\/\/[^ \t\r\n\"]*)/<a href=\"$1\" rel=\"nofollow\">$1<\/a>/gi;

        # replace www.-specified sites
        $idea =~ s/([^\/]|^)(www.[^ \t\r\n\"]*)/$1<a href=\"http:\/\/$2\" rel=\"nofollow\">$2<\/a>/g;

        # replace blabla@blabla mailtos
        $idea =~ s/([ \t\n]|^)(([^ \r\n]+)\@([^ \r\n]+))/$1<a href=\"mailto:$2\">$2<\/a>/g;
    }

    return $idea;
}


sub showit {
    $file = $_[0];
    open(MENU, "<$file");
    while(<MENU>) {
        print $_;
    }
    close(MENU);
}

sub Top {
    print "Content-Type: text/html\n\n";
    showit("../feedback.html");
}

sub Header {
    my $title = $_[0];

    title($title);

    print <<END
<p>
<a href="/donation.html"><img border="0" src="/pix/donate.png" alt="donate!" width="88" height="31" align="right"></a>
[<a href="list.cgi">List Suggestions</a>]
[<a href="addentry.cgi">Add Suggestion</a>]
[<a href="/bugreport.html">Report a Bug</a>]
END
    ;
#    print "<h1>$title</h1>\n";
}

sub Footer {
    &showit("../foot.html");
}

sub GetCategories {
    my @cats;
    open(CATS, "<info/categories");
    while(<CATS>) {
        if($_ !~ /^ *\#/) {
            # not a comment, it's a category
            chomp $_;
            push @cats, $_;
        }
    }
    close(CATS);
    return @cats;
}

sub ShowInput {

print <<EOD
<form action="add.cgi" method="post">
<center>
<table bgcolor="#000000" cellspacing=2 cellpadding=2 border=0><tr><td>
<table bgcolor="#cccccc" cellspacing=0 cellpadding=3 border=0>
<tr><td>Name     </td><td> <input type=text name=name value="$name" size=50></tr>
<tr><td>Email    </td><td> <input type=text name=email value="$email" size=50></tr>
<tr><td>Password </td><td> <input type=text name=passwd value="$passwd" size=10> (read explanation above) </tr>
<tr><td>Category </td><td> <select name=category>$cats</select> </td></tr>
<tr><td>Title    </td><td> <input type=text name=title value="$title" size=50></tr>
<tr><td colspan=2>Suggestion</td></tr>
<tr><td colspan=2>
 <textarea name=idea rows=10 cols=60 wrap=virtual>$idea</textarea></td></tr>
<tr><td><input type=submit value="submit" name=submit><input type=submit value="preview" name=preview></td>
<td align=right><input type=submit value="cancel" name=cancel></td></tr>
</table>
</td></tr></table>
</center>
</form>
EOD
    ;

}


1;
