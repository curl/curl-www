#!/usr/bin/perl
while(<STDIN>) {
    if($_ =~ s/((http|ftp):\/\/([A-Za-z0-9.\/_%\#-]*[0-9A-Za-z\/]))/<a href=\"$2:\/\/$3\">$1<\/a>/g) {
    }
    else {
        # convert <> to html-codes
        $_ =~ s/\</&lt;/g;
        $_ =~ s/\>/&gt;/g;

        # empty lines become &nbsp;
        $_ =~ s/^[ \t]*$/\&nbsp;/g;

        # trailing backslashes become \&nbsp;
        $_ =~ s/\\$/\\&nbsp;/;

        # convert the beginning of a "C comment" to a html code to prevent the
        # cpp to barf
        $_ =~ s/\/\*/&\#47;*/g;
    }
    print $_;
}
