#!/usr/bin/perl

require "./stuff.pm";
require "./pix.pm";

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

sub vernum {
    my ($v)=@_;
    my @a = split(/\./, $v);
    return ($a[0]<<16) | ($a[1] << 8) | $a[2];
}

sub sortent {
    # OS name
    my $r = lc($$a{'os'}) cmp lc($$b{'os'});
    if(!$r) {
        # OS flavour
        $r = lc($$a{'flav'}) cmp lc($$b{'flav'});
    }
    if(!$r) {
        # architecture
        $r = lc($$a{'cpu'}) cmp lc($$b{'cpu'});
    }
    if(!$r) {
        # OS version
        $r = lc($$a{'osver'}) cmp lc($$b{'osver'});
    }
    if(!$r) {
        # curl version
        $r = vernum($$b{'curl'}) <=> vernum($$a{'curl'});
    }
    if(!$r) {
        # sort prio when on same version
        $r = (0+$$b{'prio'}) <=> (0 + $$a{'prio'});
    }
    if(!$r) {
        # type (bin/devel/source/lib)
        $r = lc($$a{'type'}) cmp lc($$b{'type'});
    }
    if(!$r) {
        # SSL (yes/no)
        $r = lc($$a{'ssl'}) cmp lc($$b{'ssl'});
    }
    if(!$r) {
        # SSH (yes/no)
        $r = lc($$a{'ssh'}) cmp lc($$b{'ssh'});
    }
    return $r;
}

@sall = sort sortent @all;

my %osmap = ('Win32'    => 'Windows 32-bit',
             'Win64'    => 'Windows 64-bit',
             'Mac OS X' => 'macOS');

my $shownprev;
sub top {
    my ($os, $flav, $aname, $img)=@_;

    my $r= $osmap{$os};
    if($r) {
        $os = $r;
    }
    if($flav) {
        $os .= " - $flav";
    }
    print "<tr class=\"os\"><td class=\"ostitle\" colspan=\"3\">";
    if($img) {
        print "$aname$os</td><td class=\"oslogo\">$img</td></tr>\n";
    }
    else {
        print "$aname$os</td></tr>\n";
    }
    $shownprev = 1;

}
sub bot {
    print "<tr><td class=\"osend\" colspan=\"8\">&nbsp;</td></tr>\n";
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

print "<div class=\"oslinks\">\n";
my $p=0;
for(sort { lc($a) cmp lc($b) } keys %os) {
    if($_ ne "-") {
        if($p) {
            print "<br>\n";
        }
        my $r= $osmap{$_};
        if(!$r) {
            $r = $_;
        }
        my $anch=$_;
        $anch =~ s/[^a-zA-Z0-9]//g;
        print "<a href=\"#$anch\">$r</a>";
        $p++;
    }
}
print "</div>\n";

print "\n<p><table class=\"download2\" cellpadding=\"0\" cellspacing=\"0\">\n";
    print "<tr>\n";
    for $h (('Package',
             'Version',
             'Type',
             'Provider')) {
        print "<th>$h</th>\n";
    }
    print "</tr>\n";

my $prevos;
my $i=0;
my $utd=0; # up to date

my %shown;

my %typelong=('bin' => '<b>tool</b>',
              'devel' => 'devel',
              'source' => 'source',
              'lib' => 'libcurl');

my %formats=(   'RPM' => 'application/x-rpm',
                'deb' => 'application/x-debian-package',
                'ipk' => 'application/octet-stream',
                'iso' => 'application/octet-stream',
                'lha' => 'application/octet-stream',
                'pkg' => 'application/octet-stream',
                'tar' => 'application/x-tar',
                'tar+Z' => 'application/x-compress',
                'tar+bz2' => 'application/x-bzip2',
                'tar+gz' => 'application/x-gzip',
                'zip' => 'application/zip');

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
    my $f;
    my $flav = $$per{'flav'};
    my $os = $origs;
    $f = $flav;
    my $sortos = $origs;
    if($flav eq "-") {
        $flav = "";
    }
    elsif($flav) {
        $sortos = "$origs - $flav";
    }
    my $aname;

    if($sortos ne $prevos) {
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

        my $anch;
        if(!$shown{$s}) {
            $anch=$s;
            $anch =~ s/[^a-zA-Z0-9]//g;
            $aname= "<a name=\"$anch\"></a>";
            $shown{$s}=$anch;
        }
        my $c = "${s}${f}";
        if($flav) {
            if(!$shown{"$c"}) {
                $anch="$c";
                $anch =~ s/[^a-zA-Z0-9]//g;
                $aname .= "<a name=\"$anch\"></a>";
                $shown{"$c"}=$anch;
            }
        }
        my $img = dlpix($$per{'img'}, $s, $flav);
        if($img) {
            my $alt = "$os";
            $alt =~ s/-//g;
            $alt =~ s/  / /g;
            $img="<img alt=\"$alt\" src=\"pix/".$img."\">";
        }
        top($s, $flav, $aname, $img);
        $prevos = $sortos;
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

    my $sh = $osmap{$s};
    if($sh) {
        $s = $sh;
    }
    printf("<td class=\"col1\">%s %s %s %s</td>\n",
           $s, $flav,
           show($$per{'osver'}),
           $numcpu>1?show($$per{'cpu'}):"");

    my $fi = $$per{'file'};
    if($fi !~ /^(http|https|ftp|javascript):/) {
        $fi = "/download/$fi";
    }
    else {
        if(($fi =~ /&/) && ($fi !~ /&(lt|gt|amp|quot)\;/)) {
            $fi = CGI::escapeHTML($fi);
        }
    }

    my $contenttype;
    if ($$per{'size'} > 0) {
        # If the file is served locally, or if it is a remote binary file
        # (which a known size indicates), include its content type in the link
        $contenttype=$formats{$$per{'pack'}};
        if ($contenttype) {
            $contenttype = " type=\"$contenttype\"";
        }
    }

    printf("<td class=\"col2\"><a href=\"%s\"%s>%s</a></td>\n",
           $fi, $contenttype, $$per{'curl'});
    printf("<td class=\"col3\">%s</td>\n",
           show($typelong{$$per{'type'}}));

    my $em = show($$per{'email'});
    if($em =~ /:\/\//) {
        # email is a plain URL
    }
    elsif($em =~ /@/) {
        $em =~ s/\@/%20at%20/g;
        $em =~ s/\./%20dot%20/g;
        $em = "mailto:$em";
    }

    printf("<td class=\"col6\">%s%s%s</td>\n",
           $em?"<a href=\"$em\">":"",
           show($$per{'name'}),
           $em?"</a>":"");

    print "</tr>\n";
    $i++;
}
bot();

print "</table>";
