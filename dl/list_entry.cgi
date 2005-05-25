#!/usr/bin/perl

require "stuff.pm";

$id=CGI::param("__id");

$cgi=$ENV{"SCRIPT_NAME"};

# Ladda databasen
$db=new pbase;
$db->load($databasefilename);

# Skriv ut huvudet
lheader("List Entries");

my $per;

@all = $db->find_all("typ"=>"^entry\$");

sub sortent {
    my $r = $$a{'os'} cmp $$b{'os'};
    if(!$r) {
        $r = $$a{'flav'} cmp $$b{'flav'};
    }
    if(!$r) {
        $r = $$a{'osver'} cmp $$b{'osver'};
    }
    if(!$r) {
        $r = $$a{'cpu'} cmp $$b{'cpu'};
    }
    if(!$r) {
        $r = $$a{'file'} cmp $$b{'file'};
    }
    return $r;
}

@sall = sort sortent @all;

print "<table cellpadding=\"1\" cellspacing=\"0\"><tr class=\"tabletop\">\n";
    
for $h (('edit',
         'Package',
         'Version',
         'Details',
         'Type',
         'SSL',
 #        'Date',
         'Submitter',
 #        'Size',
         'Picture')) {
    print "<th>$h</th>\n";
}
print "</tr>\n";

sub show {
    my ($t)=@_;
    if($t eq "-") {
        return "";
    }
    return $t;
}

my $i=0;
my $utd=0; # up to date
my $auto=0; # auto or local
for $per (@sall) {
    my $cl;
    if($stable eq $$per{'curl'}) {
        $cl=" class=\"latest2\"";
        $utd++;
    }
    else {
        $cl = sprintf(" class=\"%s\"", ($i&1)?"even":"odd");
    }
    print "<tr$cl><td><a href=\"mod_entry.cgi?__id=".$$per{'__id'}."\">edit</a></td>";

    my $s = $$per{'os'};

    if($s eq "-") {
        $s = "Generic";
    }
    printf("<td>%s %s %s %s %s</td>",
           $s,
           show($$per{'osver'}),
           show($$per{'cpu'}),
           show($$per{'flav'}),
           show($$per{'pack'}));

    my $fi = $$per{'file'};
    my $here;
    if($fi !~ /^(http|ftp):/) {
        $fi = "/download/$fi";
        $here=1; # a local file, no need to auto
    }
    printf("<td><a href=\"%s\">%s</a></td>",
           $fi, $$per{'curl'});
    printf("<td>%s", $$per{'hide'} eq "Yes"?"Hide ":"");

    my $churl = $$per{'churl'};
    if($churl eq "-") {
        $churl = "";
    }
        
    printf("%s</td>", $here?"Local":($churl?"Auto":""));

    if($here || $$per{'churl'}) {
        $auto++;
    }

    printf("<td>%s</td>", $$per{'type'}eq"bin"?
           "bin":show($$per{'type'}));
    printf("<td>%s</td>",
           $$per{'ssl'}eq"Yes"?"SSL":
           $$per{'ssl'}eq"No"?"&nbsp;":$$per{'ssl'});
  #  printf("<td>%s</td>", show($$per{'date'}));

    printf("<td>%s</a></td>",
           ($$per{'name'} && $$per{'name'} ne "-")?show($$per{'name'}):"&nbsp;");
 #   printf("<td>%s</td>", show($$per{'size'}));
#    printf("<td>%s</td>",
#           $$per{'img'}?"<img src=\"/pix/".$$per{'img'}."\">":"[none]");
    printf("<td>%s</td>", $$per{'img'}?"[PIC]":"&nbsp;");
    print "</tr>\n";
    $i++;
}
print "</table>",
    "<p> $i entries, $utd is up-to-date, $auto is auto or local\n";

# Skriv ut sidfoten
lfooter();

