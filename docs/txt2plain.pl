#!/usr/bin/perl

while(<STDIN>) {
    # convert <> to html-codes
    $_ =~ s/\</&lt;/g;
    $_ =~ s/\>/&gt;/g;

    # empty lines become &nbsp;
    $_ =~ s/^[ \t]*$/\&nbsp;/g;

    # trailing backslashes become \&nbsp;
    $_ =~ s/\\$/\\&nbsp;/;

    # convert the begining of a "C comment" to a html code to prevent the
    # cpp to barf
    $_ =~ s/\/\*/&\#47;*/g;

    # convert ^#
    $_ =~ s:^ *\#:&\#35:;

    # convert URLs to <a href>
    $_ =~ s/((http|https|ftp):\/\/([a-zA-Z0-9.=\/_%?-]*[0-9A-Za-z\/]))/<a href=\"$2:\/\/$3\">$1<\/a>/g;

    print $_;
}
