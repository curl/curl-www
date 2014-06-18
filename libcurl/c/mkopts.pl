#!/usr/bin/perl

my $dir="../../cvssource/docs/libcurl/opts";

opendir(DIR, $dir) || die "can't opendir $dir: $!";
my @opts = grep { /C.*\.3\z/ && -f "$dir/$_" } readdir(DIR);
closedir DIR;

my $actions = "Makefile.opts";
my $targets = "Makefile.opttargets";
my $index = "alloptions.t";

unlink $actions;

sub single {
    my ($name) = @_;

    open(F, "<_CURLOPT_template.html");
    open(T, ">$name.gen");
    while(<F>) {
        $_ =~ s/\@template\@/$name/g;
        print T $_;
    }
    close(T);
    close(F);
}

sub makeit {
    my ($name) = @_;

    open(M, ">>$actions");
    print M <<moo
${name}.html: $name.gen \$(MANPARTS) $name.t
	\$(ACTION)
$name.t: \$(MANROOT)/opts/$name.3
	\$(MAN2HTML) <\$< >\$@

moo
    ;
    close(M);
}

my %desc;
sub shortdesc {
    my ($name) = @_;
    open (M, "<$dir/$name.3");
    my $state;
    while(<M>) {
        if($_ =~ /^\.SH NAME/) {
            $state++;
        }
        elsif($_ =~ /^$name[\\ ]*-(.*)/ && ($state == 1)) {
            $desc{$name}=$1;
            last;
        }
    }
    close(M);
}

for (@opts) {
    my $f = $_;
    $f =~ s/\.3//; # cut off the extention to get the symbol name
    push @all, $f;
    single($f);
    makeit($f);
    shortdesc($f);
}

open(TG, ">$targets");
open(IDX, ">$index");
print TG "OPTPAGES = ";
my $c = 0;
for(sort @all) {
    if($c) {
        print TG " \\\n";
    }
    print TG "  $_.html";
    $c++;

    printf IDX "<br> <a href=\"$_.html\">$_</a> - %s\n", $desc{$_};
}
close(TG);
close(IDX);
