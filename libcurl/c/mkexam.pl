#!/usr/bin/perl

my $manpage="http://curl.haxx.se/libcurl/c";

my $template="_example-templ.html";

my $dir="../../cvssource/docs/examples";

opendir(DIR, $dir) || die "can't opendir $dir: $!";
my @samps = grep { /\.c\z/ && -f "$dir/$_" } readdir(DIR);
closedir DIR;

my @mak;
my @htmlfiles;
my @basefiles;

for my $f (@samps) {
    my $base = $f;
    $base =~ s/(.*)\.c/$1/;
    my $cfile = "$base.c";
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
                $l = sprintf "$1<a href=\"%s\">%s</a>$3\n", "$manpage/$2.html", $2;
            }

            # find CURLOPT_ uses
            if($l =~ /^(.*)(CURLOPT_[A-Z_]*)(.*)/) {
                my $cut = $2;
                my ($pre, $opt, $post) = ($1, $2, $3);
                
                $cut =~ s/_//g;
                $l = sprintf "$pre<a href=\"%s\">%s</a>$post\n",
                "$manpage/curl_easy_setopt.html#$cut", $opt;
            }

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

    push @mak, "$htmlfile: $rawfile \$(MAINPARTS)\n\t\$(ACTION)\n\n";

    push @mak, "$rawfile: $dir/$cfile\n\tperl mkexam.pl\n\n";
}

open(MAK, ">Makefile.exhtml");
print MAK "EXAMPLES = ";
for my $f(@htmlfiles) {
    print MAK "$f ";
}
print MAK "\n";
close(MAK);

open(MAK, ">Makefile.examples");
print MAK @mak;
close(MAK);

open(EX, ">allex.t");
for my $b (sort @basefiles) {
    printf EX "<a href=\"%s.html\">%s.c</a><br>", $b, $b;
}
print EX "\n";
close(EX);

