#!/usr/bin/perl

require "stuff.pm";

# Ladda databasen
$db=new pbase;
$db->load($databasefilename);

my $per;

open(FILE, "<../Makefile");
while(<FILE>) {
    if($_ =~ /^STABLE= *(.*)/) {
        $stable=$1;
    }
}
close(FILE);

@all = $db->find_all("typ"=>"^entry\$");

sub sortent {
    my $r = $$a{'os'} cmp $$b{'os'};
#    if(!$r) {
#        $r = $$a{'osver'} cmp $$b{'osver'};
#    }
    if(!$r) {
        $r = $$a{'flav'} cmp $$b{'flav'};
    }
    if(!$r) {
        $r = $$a{'cpu'} cmp $$b{'cpu'};
    }
    if(!$r) {
        $r = $$a{'type'} cmp $$b{'type'};
    }
    if(!$r) {
        $r = $$a{'file'} cmp $$b{'file'};
    }
    return $r;
}

@sall = sort sortent @all;

my $shownprev;
sub top {
    my ($os, $aname, $img)=@_;

    print "<tr class=\"os\">";
    if($img) {
        print "<td class=\"ostitleleft\" colspan=\"4\">",
        "$aname$os</td>",
        "<td class=\"ostitleright\" colspan=\"3\">\n",
        "$img</td></tr>\n";
    }
    else {
        print "<td class=\"ostitle2\" colspan=\"7\">",
        "$aname$os</td></tr>\n";
    }
    $shownprev = 1;

}
sub bot {
    print "<tr><td class=\"osend\" colspan=\"7\">&nbsp;</td></tr>\n";
}

sub show {
    my ($t)=@_;
    if($t eq "-") {
        return "";
    }
    return $t;
}

my @os = $db->find_all();
my %os;
for(@os) {
    $os{$$_{'os'}}=1;
}

my $p=0;
for(sort keys %os) {
    if($_ ne "-") {
        if($p) {
            print ",\n";
        }
        my $anch=$_;
        $anch =~ s/[^a-zA-Z0-9]//g;
        print "<a href=\"#$anch\">$_</a>";
        $p++;
    }
}

print "\n<p><table class=\"download2\" cellpadding=\"0\" cellspacing=\"0\">\n";
    print "<tr>\n";    
    for $h (('Package',
             'Version',
             'Type',
             'SSL',
             'Date',
             'Provider',
             'Size')) {
        print "<th>$h</th>\n";
    }
    print "</tr>\n";

my $prevos;
my $i=0;
my $utd=0; # up to date

my %shown;

my $numcpu; # for this particular OS
my $numpack; # for this particular OS
my $numflav; # for this particular OS
for $per (@sall) {
    my $cl;
    my $img;
    my $s = $$per{'os'};
    my $origs = $s;

    if($$per{'hide'} eq "Yes") {
        # told to hide this
        next;
    }

    if($s eq "-") {
        next;
    }
    my $f = $$per{'flav'};
    my $os = "$origs - $f";
    my $aname;

    if($os ne $prevos) {
        if($prevos) {
            bot();
        }
        my @cpus = $db->find_all("os"=>"^$s\$");
        my %cpu;
        my %pack;
        my %fla;
        for(@cpus) {
            $fla{$$_{'flav'}}=1;
        }
        my @cpus = $db->find_all("os"=>"^$s\$",
                                 "flav" => "^$f\$");
        for(@cpus) {
            $cpu{$$_{'cpu'}}=1;
            $pack{$$_{'pack'}}=1;
        }
        $numcpu = scalar(keys %cpu);
        $numpack = scalar(keys %pack);
        $numflav = scalar(keys %fla);

        if(!$shown{$s}) {
            my $anch=$s;
            $anch =~ s/[^a-zA-Z0-9]//g;
            $aname= "<a name=\"$anch\"></a>";
            $shown{$s}=$anch;
        }
        my $img;
        if($$per{'img'}) {
            my $alt = "$os";
            $alt =~ s/-//g;
            $alt =~ s/  / /g;
            $img="<img width=\"200\" height=\"30\" alt=\"$alt\" src=\"/pix/".$$per{'img'}."\" border=\"0\">";
        }
        if($numflav>1) {
            my $show = $os;
            
            if($f eq "-") {
                $show = "$s - Generic";
            }
            top($show, $aname, $img);
        }
        else {
            top($s, $aname, $img);
        }
        $prevos = $os;
    }

    $s = $origs;

    if($stable eq $$per{'curl'}) {
        $cl="latest2";
        $utd++;
    }
    else {
        $cl="older2";
    }
    print "<tr class=\"$cl\">\n";

    my $mirror;
    if($$per{'re'} ne "-") {
        $mirror="<a href=\"http://curl.haxx.se/latest.cgi?curl=$$per{'re'}\">";
    }
    my $p;
    if($numpack>1) {
        $p=sprintf(" %s", show($$per{'pack'}));
    }

    my $flav = $$per{'flav'};
    if($flav eq "-") {
        $flav = "$s";
    }
    printf("<td class=\"col1\">%s%s %s %s $p%s</td>\n",
           $mirror?$mirror:"",
           $numflav>1?$flav:$s,
           show($$per{'osver'}),
           $numcpu>1?show($$per{'cpu'}):"",
           $mirror?"</a>":"");

    my $fi = $$per{'file'};
    if($fi !~ /^(http|ftp):/) {
        $fi = "/download/$fi";
    }
    else {
        $fi =~ s/\&/\&amp;/g;
    }
    printf("<td class=\"col2\"><a href=\"%s\">%s</a></td>\n",
           $fi, $$per{'curl'});
    printf("<td class=\"col3\">%s</td>\n", $$per{'type'}eq"bin"?
           "<b>bin</b>":show($$per{'type'}));
    printf("<td class=\"col4\">%s</td>\n",
           $$per{'ssl'}eq"Yes"?"<img width=\"27\" height=\"12\" alt=\"SSL enabled\" src=\"/ssl.png\">":
           $$per{'ssl'}eq"No"?"<img width=\"27\" height=\"12\" alt=\"SSL disabled\" src=\"/nossl.png\">":$$per{'ssl'});
    printf("<td class=\"col5\">%s</td>\n", show($$per{'date'}));
    my $em = show($$per{'email'});
    $em =~ s/\@/ at /g;
    $em =~ s/\./ dot /g;

    printf("<td class=\"col6\">%s%s%s</td>\n",
           $em?"<a href=\"mailto:$em\">":"",
           show($$per{'name'}),
           $em?"</a>":"");
    my $size = show($$per{'size'});
    printf("<td class=\"col7\">%s</td>\n", $size?$size:"&nbsp;");
    print "</tr>\n";
    $i++;
}
bot();

print "</table>";

