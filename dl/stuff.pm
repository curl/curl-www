# Hjälpfunktioner för formulärinmatningar.

require "CGI.pm";
require "pbase.pm";
require "../curl.pm";

$databasefilename = "data/databas.db";

sub getheader {
    my ($title)=@_;
    my @head;

    if ($title eq "") {
        $title="curl packages";
    }

    open(FILE, "<../Makefile");
    while(<FILE>) {
        if($_ =~ /^STABLE= *(.*)/) {
            $stable=$1;
        }
    }
    close(FILE);

    # valid login-user, continue
    push @head, <<MOO
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head><title>$title</title>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link rel="stylesheet" type="text/css" href="/curl.css">
</head>
<body>
<a href="/dl/list_entry.cgi">[List Entries]</a>
<a href="/dl/mod_entry.cgi">[New Entry]</a>
<a href="/download.html">[Download Page]</a>
<a href="/dl/log/">[Remcheck Logs]</a>
<div class="pagetitle">$title</div>
MOO
;
    return @head;
}

sub lheader {
    print "Content-Type: text/html; charset=UTF-8\n\n";
    print getheader(@_);
}


sub lfooter {
    print <<FOOT
</body></html>
FOOT
;
}


sub inputstuff::save_input 
{
    my %data=(@_);
    $data{"modify_time"}=time();       # stundens sekund

    my $act = CGI::param("action");

    if ($act eq "Save As New Entry") {
        $id = "";
        $act = "Save";
    }

    if ($act eq "Save") {
        if ($id) {
            my $ref=$db->get("id"=>$id);
            if ($$ref{"modify_time"} != CGI::param("modify_time")) {
                $warning_message="Your changes aren't saved, someone else ".
                    "changes the contents before you!";
            } else {
                $db->change("id", $id, %data);
                if ($db->save() == -1) {
                    $warning_message="Failed while saving database!";
                } else {
                    $result_message="Added entry";
                }
            }
        }
        else {
            my $newid=$db->add(%data);
            if ($db->save() == -1) {
                $warning_message="Failed saving database!";
            } else {
                $result_message="Added entry";
            }
        }
    } elsif ($act eq "Remove") {
        if (CGI::param("remove_check") != 1) {
            $warning_message="Not removed. Check the box to remove for real.";
        } elsif ($id ne "") {
            my $ref=$db->get("id"=>$id);
            if ($$ref{"modify_time"} != CGI::param("modify_time")) {
                $warning_message="Your changes aren't saved, someone else ".
                    "changes the contents before you!";
            } elsif (!$db->delete("id", $id)) {
                if ($db->save() == -1) {
                    $warning_message="Failed to save database!";
                } else {
                    $result_message="Entry removed!";
                    # Log data
                }
                $id="";
            } else {
                $warning_message="Couldn't remove the entry!";
            }
        }
    }
    else {
        $warning_message = "Unsupported action received: $act";
    }
}

############
# Skriv ut informationstext
sub inputstuff::show_extra_messages 
{
    if ($warning_message ne "") {
        print "<p class=\"alert\">$warning_message</p>\n";
    }
    if ($result_message ne "") {
        print "<p class=\"info\">$result_message</p>\n";
    }
}



#### Formulärfot
sub inputstuff::form_footer()
{
    print "<input type=\"submit\" name=\"action\" value=\"Save\"><br>\n";
        
    if ($id) {
        print "<input type=\"submit\" name=\"action\" value=\"Save As New Entry\"><br>";

        print "<input type=\"submit\" name=\"action\" value=\"Remove\">",
        "&nbsp;confirm:<input type=checkbox ",
        "name=\"remove_check\" value=\"1\">\n";
    }
    
    print "</form>\n";

################Slut på formulär
}

1;
