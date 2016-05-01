#!/usr/bin/perl

my $manpage="https://curl.haxx.se/libcurl/c";

my $template="_example-templ.html";

my $dir="../../cvssource/docs/examples";

opendir(DIR, $dir) || die "can't opendir $dir: $!";
my @samps = grep { /\.(c|cpp)\z/ && -f "$dir/$_" } readdir(DIR);
closedir DIR;

my @mak;
my @htmlfiles;
my @basefiles;

my %type;

for my $f (@samps) {
    my $base = $f;
    my $ext;
    if($base =~ /^(.*)\.(c|cpp)\z/) {
        $base = $1;
        $ext = $2;
    }
    my $cfile = "$base.$ext";
    my $encfile = "$base.et";
    my $rawfile = "$base.t";
    my $htmlfile = "$base.html";

    my $cmd = sprintf("enscript %s -w html -o - --color -Ec -q ",
                      "$dir/$cfile");
    open(OUT, ">$rawfile");
    open(F, "<$template") ||
        next;

    while(<F>) {
        s/%cfile%/$cfile/g;
        s/%htmlfile%/$htmlfile/g;
        s/%rawfile%/$encfile/g;

        print OUT $_;
    }
    close(OUT);
    close(F);

    # now run enscript and extract the PRE part and linkify some of the libcurl
    # stuff
    # 
    open(ET, ">$encfile");
    open(CMD, "$cmd|");
    my $show=0;
    while(<CMD>) {
        if($_ =~ /^<PRE/) {
            $show = 1;
        }

        if($show) {
            my $l=$_;

            # find curl_ function invokes
            if($l =~ /^(.*)(curl_[a-z_]*)( *\(.*)/) {
                $l = "$1<a href=\"$manpage/$2.html\">$2</a>$3\n";
            }

            # find CURLOPT_ and CURLMOPT_ option names
            if($l =~ /^(.*)((CURLOPT|CURLMOPT|CURLINFO)_[A-Z_]*)(.*)/) {
                my $cut = $2;
                my ($pre, $opt, $post) = ($1, $2, $4);

                # a dedicated web page exists for this option, link to that
                $l = "$pre<a href=\"$manpage/$opt.html\">$opt</a>$post\n";
            }

            # replace backslashes
            $l =~ s/\\\n/\\&nbsp;\n/g;

            if($l eq "\n") {
                print ET "&nbsp;\n";
            }
            else {
                print ET $l;
            }
            if($_ =~ /^<\/PRE/) {
                $show = 0;
            }
        }
    }
    close(ET);
    close(CMD);

    push @htmlfiles, $htmlfile;
    push @basefiles, $base;

    $type{$base}=$ext;

    push @mak, "$htmlfile: $rawfile \$(MAINPARTS)\n\t\$(ACTION)\n\n";

    push @mak, "$rawfile: $dir/$cfile mkexam.pl\n\tperl mkexam.pl\n\n";
}

open(MAK, ">Makefile.exhtml");
print MAK "EXAMPLES = ";
for my $f(@htmlfiles) {
    print MAK "$f ";
}
print MAK "\n\n";

print MAK "EXAMPLESRCS = ";
for my $f(@samps) {
    print MAK "$dir/$f ";
}

close(MAK);

open(MAK, ">Makefile.examples");
print MAK @mak;
close(MAK);

sub desc {
    my ($file) = @_;
    my $get=0;
    my @d;

    open(F, "<$dir/$file");
    while(<F>) {
        if($_ =~ /^\/\* \<DESC\>/) {
            $get = 1;
        }
        elsif($get && ($_ =~ /^ \* \<\/DESC\>/)) {
            # done!
            return join(" ", @d);
        }
        elsif($get && ($_ =~ /^ \* (.*)/)) {
            push @d, $1,
        }
    }
}

open(EX, ">allex.t");
open(DESC, ">allex-desc.t");
print DESC "<table>\n";
my $i=0;
for my $b (sort @basefiles) {
    my $d = desc("$b.".$type{$b});
    my $t = $type{$b} eq "cpp"?" (C&plus;&plus;)":"";

    printf EX "<a href=\"%s.html\">%s</a>$t<br>\n", $b, $b,
    printf DESC ("<tr class=\"%s\"><td><a href=\"%s.html\">%s</a> $t</td><td>%s</td>",
                 $i&1?"odd":"even",
                 $b, $b, $d);
    $i++;
}
print EX "\n";
print DESC "</table>\n";
close(EX);
close(DESC);
