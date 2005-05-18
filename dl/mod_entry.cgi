#!/usr/bin/perl

require "stuff.pm";

# databasfält:
%data=("typ"=>"entry",
       "os"=>CGI::param("os"),
       "osver"=>CGI::param("osver"),
       "flav"=>CGI::param("flav"),
       "cpu"=>CGI::param("cpu"),
       "ssl"=>CGI::param("ssl"),
       "type"=>CGI::param("type"),
       "pack"=>CGI::param("pack"),
       "file"=>CGI::param("file"),
       "curl"=>CGI::param("curl"),
       "date"=>CGI::param("date"),
       "size"=>CGI::param("size"),
       "name"=>CGI::param("name"),
       "email"=>CGI::param("email"),
       "re"=>CGI::param("re"),
       "resp"=>CGI::param("resp"),
       "img"=>CGI::param("img"),
       "hide"=>CGI::param("hide"),
       "churl"=>CGI::param("churl"),
       "chregex"=>CGI::param("chregex"),
       );

$id=CGI::param("__id");

$cgi=$ENV{"SCRIPT_NAME"};

# Ladda databasen
$db=new pbase;
$db->load($databasefilename);

$ref="";
if ($id ne "") {
    $ref=$db->get("id"=>$id);
    $title="Modify Entry: $$ref{'file'}";
    $p = $$ref{'grp'}; # hemvist
}
else {
    $title="Add Entry";
}
# Skriv ut huvudet
lheader($title);

if (CGI::param("action")) {
    # get the pre- values if they're set instead of the "original" ones
    for(keys %data) {
        my $d = CGI::param("pre-".$_);
        if(($d ne "new") && ($data{$_} eq "")) {
            $data{$_}=$d;
        }
        else {
            $data{$_} = CGI::escapeHTML($data{$_});
        }
    }
    &inputstuff::save_input(%data);
}


############
# Skriv ut informationstext
&inputstuff::show_extra_messages();

&my_show_form();

#### Formulärfot
&inputstuff::form_footer();

# Skriv ut sidfoten
lfooter();

# show a read-only (for this form) variable
sub information {
    my ($desc, $short, $explain)=@_;
    print "<tr><td class=\"desc\">$desc:</td><td>";
    print CGI::escapeHTML($$ref{$short})." ($explain)</td></tr>\n";
}

sub alternative {
    my ($desc, $short, $explain, $len)=@_;

    my $per;
    my %hash;

    for $per ($db->find_all()) {
        my $val=$$per{$short};
        $hash{$val}=1;
    }

    print "<tr><td class=\"desc\">$desc:</td><td>";

    my $found;
    if(scalar(keys %hash)) {
        print "<select name=\"pre-$short\">\n";
        print "<option value=\"new\">Use text-field</option>\n";
        for(sort keys %hash) {
            my $s;
            if(!$_) {
                next;
            }
            if($_ eq $$ref{$short}) {
                $s= " selected";
                $found=$_;
            }
            my $val = $_;#CGI::escapeHTML($_);

            # while we continue to have a few unescaped things in the
            # database, we scan for a few known villain and run escape on the
            # string then.
            if($val =~ /[<>]/) {
                $val = CGI::escapeHTML($val);
            }
            elsif(($val =~ /&/) && ($val !~ /&(lt|gt|amp|quot)\;/)) {
                $val = CGI::escapeHTML($val);
            }

            print "<option$s>$val</option>\n";
        }
        print "</select>\n";
    }

    if(!$len) {
        $len=20;
    }
    print "<input type=text size=\"$len\" name=\"$short\" value=\"";
    if(!$found) {
        print CGI::escapeHTML($$ref{$short});
    }
    printf "\">%s $explain</td>\n",
    $found =~ /^(http|ftp|https):/?"<a href=\"$found\">URL</a>":"";

    print "</tr>\n";
}

sub my_show_form()
{
#####################################################3
##### Visa formuläret
    print "<form action=\"$cgi\" method=\"post\">\n";
##### Dolda saker
    if ($id ne "") {
        print "<input type=hidden name=\"__id\" value=\"$id\">\n";
        print "<input type=hidden name=\"modify_time\" value=\"";
        print $$ref{"modify_time"},"\">\n";
    }

    print "<table class=\"mod_entry\">";

##### Textinmatning

    alternative("Operating System", "os",
                "Windows / AIX / Linux / Solaris / etc");

    alternative("OS Version", "osver",
                "4.1 / 11.00 / 2.6 / 2000 / etc");

    alternative("Flavour", "flav",
                "mingw32 / cygwin / Borland / etc");

    alternative("Image", "img",
                "file name of image for this OS/flavour");

    alternative("CPU", "cpu",
                "i386 / i686 / PowerPC / StrongARM / etc");

    alternative("SSL-enabled", "ssl",
                "Yes / No");

    alternative("Package Type", "type",
                "devel / source / bin / docs / OTHER");

    alternative("Package Format", "pack",
                "RPM / deb / tar / tar+gz / OTHER");

    alternative("File/URL", "file", "file name / URL", 50);

    alternative("curl version", "curl",
                "7.10.3 or similar");

    alternative("Date", "date",
                "YYYY-MM-DD");

    alternative("File Size", "size",
                "in bytes");

    alternative("Packager Name", "name",
                "Full name");

    alternative("Packager Email/URL", "email",
                "name\@somwhere.com or URL");

    alternative("Regex-name", "re",
                "name of the package regex, see latest.cgi");

    alternative("Uploader", "resp",
                "username of the person responsible for this package");

    alternative("Hide from download page", "hide",
                "'Yes' makes this entry not appear in the HTML output");

    alternative("Autocheck this URL", "churl",
                "\$version gets replaced", 50);

    alternative("Match this regex in the autocheck URL", "chregex",
                "make sure the first () group extracts the version number, unless \$version is part of check URL", 40);

    information("Remcheck", "remcheck", "Most recent successful check");
    information("Remcheck update", "remdate",
                "Last updated by remcheck");

###slut
    print "</table>\n";
}

