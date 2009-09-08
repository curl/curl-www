#!/usr/bin/perl

my $template="_example-templ.html";

my $dir="../../cvssource/docs/examples";

opendir(DIR, $dir) || die "can't opendir $dir: $!";
my @samps = grep { /\.c\z/ && -f "$dir/$_" } readdir(DIR);
closedir DIR;

my @mak;
my @htmlfiles;

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

    # now run enscript and extract the PRE part
    # 
    open(ET, ">$encfile");
    open(CMD, "$cmd|");
    my $show=0;
    while(<CMD>) {
        if($_ =~ /^<PRE/) {
            $show = 1;
        }

        if($show) {
            if($_ eq "\n") {
                print ET "&nbsp;\n";
            }
            else {
                print ET $_;
            }
            if($_ =~ /^<\/PRE/) {
                $show = 0;
            }
        }
    }
    close(ET);
    close(CMD);

    push @htmlfiles, $htmlfile;

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
