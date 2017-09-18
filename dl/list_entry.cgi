#!/usr/bin/perl

require "stuff.pm";
require "dtime.pm";

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
    
for $h (('Package',
         'Version',
         'Update',
         'Type',
         'SSL',
         'SSH',
         'Who',
         'Pic',
         'Check', 'Comment')) {
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

sub since {
    my ($then)=@_;

    if($then =~ /^(\d\d\d\d)(\d\d)(\d\d)-(\d\d)(\d\d)(\d\d)/) {
        my ($year, $mon, $day, $hour, $min, $sec)=($1,$2,$3,$4,$5,$6);
        my $ttime = timelocal($sec, $min, $hour, $day, $mon-1, $year-1900);

        return sprintf("%d d", (time()-$ttime)/(24*60*60));
    }
    else {
        return "!";
    }
}

my $i=0;
my $utd=0; # up to date
my $auto=0; # auto or local
my $hidden=0; # hidden
for $per (@sall) {
    my $cl;
    if($stable eq $$per{'curl'}) {
        $cl=" class=\"latest2\"";
        $utd++;
    }
    else {
        $cl = sprintf(" class=\"%s\"", ($i&1)?"even":"odd");
    }

    my $s = $$per{'os'};

    if($s eq "-") {
        $s = "Generic";
    }
    my $packname =
        sprintf("%s %s %s %s %s",
                $s,
                show($$per{'osver'}),
                show($$per{'cpu'}),
                show($$per{'flav'}),
                show($$per{'pack'}));
    if($packname =~ /^[ \t]$/) {
        $packname = "nameless";
    }

    print "<tr$cl><td><a href=\"mod_entry.cgi?__id=".$$per{'__id'}."\">$packname</a></td>";

    my $fi = $$per{'file'};
    my $here;
    if($fi !~ /^(http|ftp):/) {
        $fi = "/download/$fi";
        $here=1; # a local file, no need to auto
    }
    printf("<td><a href=\"%s\">%s</a></td>",
           $fi, $$per{'curl'});
    printf("<td>%s", $$per{'hide'} eq "Yes"?"Hide ":"");
    if($$per{'hide'} eq "Yes") {
        $hidden++;
    }

    my $churl = $$per{'churl'};
    if($churl eq "-") {
        $churl = "";
    }
        
    printf("%s</td>", $here?"Local":($churl?"Auto":""));

    if($here || $$per{'churl'}) {
        $auto++;
    }
    my $type = $$per{'type'};
    $type =~ s/source/src/;
    $type =~ s/devel/dev/;
    printf("<td>%s</td>", show($type));

    printf("<td>%s</td>",
           $$per{'ssl'}eq"Yes"?"SSL":
           $$per{'ssl'}eq"No"?"&nbsp;":$$per{'ssl'});

    printf("<td>%s</td>",
           $$per{'ssh'}eq"Yes"?"SSH":
           $$per{'ssh'}eq"No"?"&nbsp;":$$per{'ssh'});

    printf("<td>%s</a></td>",
           ($$per{'name'} && $$per{'name'} ne "-")?show($$per{'name'}):"&nbsp;");
 #   printf("<td>%s</td>", show($$per{'size'}));
#    printf("<td>%s</td>",
#           $$per{'img'}?"<img src=\"/pix/".$$per{'img'}."\">":"[none]");
    printf("<td>%s</td>", $$per{'img'}?"pic":"&nbsp;");

    printf("<td>%s</td>",
           $here?"-":($churl?since($$per{'remcheck'}):"manual"));
    if($$per{'file'} =~ /^(http|ftp):/) {
        print "<td> UNSAFE URL</td>\n";
    }
    print "</tr>\n";
    $i++;
}
print "</table>",
    "<p> $i entries, $utd is up-to-date, $auto is auto or local, $hidden are hidden\n";

# Skriv ut sidfoten
lfooter();

