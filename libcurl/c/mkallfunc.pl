#!/usr/bin/perl

my $docsdir = $ARGV[0];

opendir(my $dh, $docsdir) || die "cannot opendir $some_dir: $!";
my @manp = grep { /^curl_.*\.md/ } readdir($dh);
closedir $dh;

my %func;
my %file;

sub htmlver {
    my ($f)=@_;
    $f =~ s/\.md/.html/;
    $f =~ s/^.*\///;
    return $f;
}

sub manpage {
    my ($file)=@_;
    open(P, "<$file");
    my $name = 0;
    my @f;
    while(<P>) {
        my $l = $_;
        chomp $l;
        if(/^# NAME/) {
            $name = 1;
        }
        elsif(/^#/ && $name) {
            last;
        }
        elsif($name) {
            my $desc;
            if($l =~ /(.*) - (.*)/) {
                $desc = $2;
                $l = $1;
            }
            for(split(/, */, $l)) {
                push @f, $_;
            }
            if($desc) {
                for(@f) {
                    $func{$_} = $desc;
                    $file{$_} = htmlver($file);
                }
            }
        }
    }
}


for my $d (@manp) {
    manpage("$docsdir/$d");
}

print "<table>\n";
my $even = 0;
for my $f (sort keys %func) {
    printf "<tr class=\"%s\"><td><a href=\"%s\">%s</a></td><td>%s</td></tr>\n",
        $even ? "even" : "odd",
        $file{$f}, $f, $func{$f};
    $even ^= 1;
}
print "</table>\n";
