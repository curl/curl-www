#!/usr/bin/perl

require "stuff.pm";

$id=CGI::param("__id");

$cgi=$ENV{"SCRIPT_NAME"};

# Ladda databasen
$db=new pbase;
$db->load($databasefilename);

# Skriv ut huvudet
header("List Entries");

my $per;

@all = $db->find_all("typ"=>"^entry\$");

sub sortent {
    my $r = $$a{'os'} cmp $$b{'os'};
    if(!$r) {
        $r = $$a{'osver'} cmp $$b{'osver'};
    }
    if(!$r) {
        $r = $$a{'cpu'} cmp $$b{'cpu'};
    }
    if(!$r) {
        $r = $$a{'flav'} cmp $$b{'flav'};
    }
    if(!$r) {
        $r = $$a{'file'} cmp $$b{'file'};
    }
    return $r;
}

@sall = sort sortent @all;

print "<table><tr>\n";
    
for $h (('edit',
         'Package',
         'Version',
         'Hidden',
         'Type',
         'SSL',
         'Date',
         'Submitter',
         'Size',
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
for $per (@sall) {
    my $cl;
    if($stable eq $$per{'curl'}) {
        $cl=" class=\"buildfine\"";
        $utd++;
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
    if($fi !~ /^(http|ftp):/) {
        $fi = "/download/$fi";
    }
    printf("<td><a href=\"%s\">%s</a></td>",
           $fi, $$per{'curl'});
    printf("<td>%s</th>", $$per{'hide'} eq "Yes"?"Hide":"");
    printf("<td>%s</td>", $$per{'type'}eq"bin"?
           "<b>bin</b>":show($$per{'type'}));
    printf("<td>%s</td>",
           $$per{'ssl'}eq"Yes"?"<b>SSL</b>":
           $$per{'ssl'}eq"No"?"&nbsp;":$$per{'ssl'});
    printf("<td>%s</td>", show($$per{'date'}));
    my $em = show($$per{'email'});
    printf("<td><a href=\"%s\">%s</a></td>",
           $em?"mailto:".$em:"",
           show($$per{'name'}));
    printf("<td>%s</td>", show($$per{'size'}));
    printf("<td>%s</td>",
           $$per{'img'}?"<img src=\"/pix/".$$per{'img'}."\">":"&nbsp;");
    print "</tr>\n";
    $i++;
}
print "</table>",
    "<p> $i entries, $utd is up-to-date\n";

# Skriv ut sidfoten
footer();

